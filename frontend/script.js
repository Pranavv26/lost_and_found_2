// script.js — Shared utilities for Lost and Found frontend
// Plain JavaScript, no framework

const API = 'http://localhost:3000'

// ── Fetch helpers ─────────────────────────────────────────

async function getJSON(endpoint) {
  const res = await fetch(API + endpoint)
  if (!res.ok) throw new Error(`GET ${endpoint} failed: ${res.status}`)
  return res.json()
}

async function postJSON(endpoint, body) {
  const res = await fetch(API + endpoint, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify(body)
  })
  if (!res.ok) throw new Error(`POST ${endpoint} failed: ${res.status}`)
  return res.json()
}

async function patchJSON(endpoint, body) {
  const res = await fetch(API + endpoint, {
    method:  'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify(body)
  })
  if (!res.ok) throw new Error(`PATCH ${endpoint} failed: ${res.status}`)
  return res.json()
}

// ── UI helpers ────────────────────────────────────────────

function statusBadge(status) {
  return `<span class="badge badge-${status}">${status}</span>`
}

function showAlert(id, message, type = 'success') {
  const el = document.getElementById(id)
  if (!el) return
  el.textContent  = message
  el.className    = `alert alert-${type}`
  el.style.display = 'block'
  setTimeout(() => { el.style.display = 'none' }, 3500)
}

function setActive(links, target) {
  links.forEach(l => l.classList.toggle('active', l === target))
}

// ── Populate user dropdowns ───────────────────────────────

async function populateUserSelect(selectId) {
  const select = document.getElementById(selectId)
  if (!select) return
  try {
    const users = await getJSON('/users')
    select.innerHTML = '<option value="">— select user —</option>' +
      users.map(u => `<option value="${u.user_id}">${u.name} (${u.role})</option>`).join('')
  } catch (e) {
    console.error('Could not load users:', e.message)
  }
}

// ── Populate item dropdowns ───────────────────────────────

async function populateItemSelect(selectId, statusFilter = null) {
  const select = document.getElementById(selectId)
  if (!select) return
  try {
    const endpoint = statusFilter ? `/items/status/${statusFilter}` : '/items'
    const items = await getJSON(endpoint)
    select.innerHTML = '<option value="">— select item —</option>' +
      items.map(i => `<option value="${i.item_id}">[${i.item_id}] ${i.name} (${i.status})</option>`).join('')
  } catch (e) {
    console.error('Could not load items:', e.message)
  }
}

// ── Mark current nav link active ──────────────────────────

function markCurrentNav() {
  const page = window.location.pathname.split('/').pop()
  document.querySelectorAll('.nav-links a').forEach(a => {
    const href = a.getAttribute('href').split('/').pop()
    if (href === page || (page === '' && href === 'index.html')) {
      a.classList.add('active')
    }
  })
}

document.addEventListener('DOMContentLoaded', markCurrentNav)
