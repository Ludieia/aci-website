(function () {
  'use strict';

  var DEFAULT_ENDPOINT = 'http://178.156.210.71:3000/agent-task';
  var config = window.ACICORP_FORMS_CONFIG || {};
  var endpoint = config.endpoint || DEFAULT_ENDPOINT;
  var environment = config.environment || 'test';

  function makeTransactionId(formName) {
    var safeForm = String(formName || 'form').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 28) || 'form';
    var now = new Date();
    var stamp = now.toISOString().replace(/[-:TZ.]/g, '').slice(0, 14);
    var random = Math.random().toString(36).slice(2, 8).toUpperCase();
    return 'ACI-' + safeForm.toUpperCase() + '-' + stamp + '-' + random;
  }

  function getTraceId() {
    if (window.crypto && crypto.randomUUID) return crypto.randomUUID();
    return 'trace-' + Date.now().toString(36) + '-' + Math.random().toString(36).slice(2, 10);
  }

  function setStatus(form, message, type) {
    var target = form.querySelector('[data-form-status]');
    if (!target) return;
    target.textContent = message || '';
    target.className = 'form-status ' + (type || '');
  }

  function readFormData(form) {
    var raw = new FormData(form);
    var payload = {};
    raw.forEach(function (value, key) {
      if (value instanceof File) {
        if (value && value.name) payload[key] = { file_name: value.name, size: value.size, type: value.type };
        return;
      }
      if (payload[key]) {
        if (!Array.isArray(payload[key])) payload[key] = [payload[key]];
        payload[key].push(value);
      } else payload[key] = value;
    });
    return payload;
  }

  function validateRequired(form) {
    var missing = [];
    form.querySelectorAll('[required]').forEach(function (field) {
      if (field.type === 'checkbox' && !field.checked) missing.push(field.getAttribute('data-label') || field.name || 'required checkbox');
      else if (field.type !== 'checkbox' && !String(field.value || '').trim()) missing.push(field.getAttribute('data-label') || field.name || 'required field');
    });
    var email = form.querySelector('input[type="email"]');
    if (email && email.value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) missing.push('valid email');
    return missing;
  }

  function buildPrompt(formName, formData, transactionId, traceId) {
    return 'Process ACICORP public website form submission. Form: ' + formName + '. Transaction ID: ' + transactionId + '. Trace ID: ' + traceId + '. Payload JSON: ' + JSON.stringify(formData);
  }

  async function submitForm(form) {
    var formName = form.getAttribute('data-acicorp-form') || 'unknown';
    var missing = validateRequired(form);
    if (missing.length) {
      setStatus(form, 'Please complete: ' + missing.join(', ') + '.', 'error');
      return;
    }

    var submitButton = form.querySelector('button[type="submit"], .btn[type="submit"]');
    if (submitButton) submitButton.disabled = true;
    setStatus(form, 'Sending securely to Ludie IA...', 'pending');

    var transactionId = makeTransactionId(formName);
    var traceId = getTraceId();
    var formData = readFormData(form);
    var payload = {
      agent_name: 'ACICORP Intake Agent',
      task_type: 'form_submission',
      prompt: buildPrompt(formName, formData, transactionId, traceId),
      target_system: 'ERPNext',
      source: 'acicorpinc.com',
      source_channel: 'website',
      form_name: formName,
      environment: environment,
      transaction_id: transactionId,
      trace_id: traceId,
      timestamp_utc: new Date().toISOString(),
      payload: formData
    };

    console.info('[ACICORP Form]', 'submit_attempt', { form_name: formName, transaction_id: transactionId, trace_id: traceId });

    try {
      var response = await fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-ACICORP-Transaction-ID': transactionId, 'X-ACICORP-Trace-ID': traceId },
        body: JSON.stringify(payload)
      });
      var contentType = response.headers.get('content-type') || '';
      var body = contentType.indexOf('application/json') >= 0 ? await response.json() : { message: await response.text() };
      if (!response.ok || body.success === false) {
        console.error('[ACICORP Form]', 'submit_failed', { status: response.status, transaction_id: transactionId, body: body });
        setStatus(form, 'Submission failed. Reference: ' + transactionId + '. Please try again or contact ACICORP.', 'error');
        return;
      }
      console.info('[ACICORP Form]', 'submit_success', { transaction_id: transactionId, response: body });
      form.reset();
      setStatus(form, 'Your request has been received. Reference ID: ' + transactionId + '.', 'success');
    } catch (error) {
      console.error('[ACICORP Form]', 'network_or_cors_error', { transaction_id: transactionId, error: error && error.message ? error.message : error });
      setStatus(form, 'Unable to submit now. Reference: ' + transactionId + '. Please try again later.', 'error');
    } finally {
      if (submitButton) submitButton.disabled = false;
    }
  }

  document.addEventListener('submit', function (event) {
    var form = event.target.closest('form[data-acicorp-form]');
    if (!form) return;
    event.preventDefault();
    submitForm(form);
  });
})();
