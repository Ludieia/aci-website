# ACICORP Inc. Admin Space Architecture

This document defines a simple two-phase architecture for managing public website content without touching Nginx, SSL, DNS, Cloudflare, or deploy.sh.

## Objective

Create a safe administrative workflow for ACICORP Inc. to manage:

- blog articles
- videos
- photos
- pages
- received forms
- human corrections before publication

## Phase 1 — Rapid and Safe MVP

### Principle

Use GitHub and static files as the temporary content management system. No complex login is added to the public website. Content is created, reviewed, approved, and then published through GitHub commits and the existing VPS deploy workflow.

### Tools

- GitHub repository: Ludieia/aci-website
- Static JSON files for content queues
- HTML pages generated manually or by Ludie IA
- Human validation before publication
- Existing deploy workflow:

```bash
cd /opt/aci-website
git pull
./deploy.sh
```

### Proposed structure

```text
/admin/
  index.html
  admin.css
  admin.js
  content-queue.json

/content/
  blog.json
  photos.json
  videos.json
  pages.json
  form-submissions.json

/pages/
  blog.html
  article-pages.html
```

### Phase 1 workflow

1. Editor prepares content.
2. Ludie IA formats and validates the content.
3. Content enters a JSON queue with status `draft`.
4. Super Administrator reviews content.
5. Approved content is committed to GitHub.
6. VPS deploys with `git pull` and `./deploy.sh`.
7. Public website shows the updated content.

### Content statuses

- draft
- needs_review
- approved
- published
- rejected
- archived

### Human validation rules

No article, photo, video, or page correction should be published without one of these validations:

- Super Administrator approval
- authorized Admin approval
- Editor submits only to review, not direct publication

## Phase 2 — Advanced Admin Platform

### Target domain

```text
admin.acicorpinc.com
```

### Required capabilities

- secure login
- roles and permissions
- dashboard
- image/video upload
- draft / review / published workflow
- revision history
- audit trail
- connection with ERPNext and Ludie IA

### Roles

#### Super Admin

- full access
- approve publication
- manage users
- delete or archive content
- manage website settings
- validate sensitive forms

#### Admin

- create and edit content
- review submissions
- approve non-sensitive content if authorized
- manage media library

#### Editor

- create blog drafts
- upload draft media
- suggest corrections
- submit to review
- cannot publish directly

### Advanced architecture

```text
admin.acicorpinc.com
  login
  dashboard
  content manager
  media library
  form submissions
  review queue
  publication history
  user roles

Ludie IA
  content assistance
  correction assistance
  form routing
  validation support

ERPNext
  donor records
  chaplain profiles
  volunteer records
  partner records
  donation tracking
  field reports
```

### Integration flow

```text
Public Website
  → Form Submission
  → Ludie IA /agent-task
  → ERPNext CRM
  → Admin dashboard review
  → human validation
  → publication or follow-up
```

### Security rules

- no ERPNext API keys in frontend
- no Ludie IA secrets in frontend
- HTTPS required
- role-based access control
- audit trail for changes
- media upload validation
- form spam protection
- backup before major updates

## Immediate frontend deliverables

Phase 1 includes a static admin preview located at:

```text
/admin/index.html
```

It is not a secure production admin. It is a visual and workflow prototype to organize content management before the advanced version is built.

## Final recommendation

Use Phase 1 immediately for disciplined content validation through GitHub. Build Phase 2 when ACICORP Inc. is ready for a real secured admin portal with authentication, roles, media upload, ERPNext, and Ludie IA integration.
