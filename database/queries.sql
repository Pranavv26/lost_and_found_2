-- ============================================================
--  Lost and Found Management System
--  queries.sql — All SQL operations used in the project
-- ============================================================

USE lost_and_found;

-- ── Basic SELECTs ─────────────────────────────────────────
SELECT * FROM users;
SELECT * FROM items;
SELECT * FROM claims;
SELECT * FROM lost_reports;
SELECT * FROM found_reports;

-- ── Filter by status ──────────────────────────────────────
SELECT * FROM items  WHERE status = 'lost';
SELECT * FROM items  WHERE status = 'found';
SELECT * FROM items  WHERE status = 'claimed';
SELECT * FROM claims WHERE status = 'requested';
SELECT * FROM claims WHERE status = 'approved';
SELECT * FROM claims WHERE status = 'rejected';

-- ── Search ────────────────────────────────────────────────
SELECT * FROM items WHERE name LIKE '%wallet%' OR description LIKE '%wallet%';
SELECT * FROM items WHERE category = 'Electronics';

-- ── Lost items with reporter name (JOIN) ──────────────────
SELECT
    i.item_id,
    i.name          AS item_name,
    i.category,
    i.status,
    u.name          AS reported_by,
    lr.lost_location,
    lr.lost_date
FROM items i
JOIN lost_reports lr ON i.item_id  = lr.item_id
JOIN users u         ON lr.user_id = u.user_id;

-- ── Found items with finder name (JOIN) ───────────────────
SELECT
    i.item_id,
    i.name          AS item_name,
    i.category,
    u.name          AS found_by,
    fr.found_location,
    fr.found_date
FROM items i
JOIN found_reports fr ON i.item_id  = fr.item_id
JOIN users u          ON fr.user_id = u.user_id;

-- ── Claims with item and claimant details (JOIN) ──────────
SELECT
    c.claim_id,
    i.name   AS item_name,
    u.name   AS claimed_by,
    c.status,
    c.notes,
    c.claim_date
FROM claims c
JOIN items i ON c.item_id    = i.item_id
JOIN users u ON c.claimed_by = u.user_id;

-- ── Claims with reviewer (LEFT JOIN) ─────────────────────
SELECT
    c.claim_id,
    i.name   AS item_name,
    u.name   AS claimed_by,
    c.status,
    r.name   AS reviewed_by,
    c.claim_date
FROM claims c
JOIN      items i ON c.item_id     = i.item_id
JOIN      users u ON c.claimed_by  = u.user_id
LEFT JOIN users r ON c.reviewed_by = r.user_id;

-- ── Approve a claim ───────────────────────────────────────
UPDATE claims
SET status = 'approved', reviewed_by = 1
WHERE claim_id = 2;

-- ── Reject a claim ────────────────────────────────────────
UPDATE claims
SET status = 'rejected',
    notes  = 'Ownership could not be verified',
    reviewed_by = 1
WHERE claim_id = 4;

-- ── Update item status to claimed ─────────────────────────
UPDATE items SET status = 'claimed' WHERE item_id = 4;

-- ── Count items by status (GROUP BY) ─────────────────────
SELECT status, COUNT(*) AS total FROM items  GROUP BY status;
SELECT status, COUNT(*) AS total FROM claims GROUP BY status;

-- ── Total items per category ──────────────────────────────
SELECT category, COUNT(*) AS total FROM items GROUP BY category;

-- ── Delete a claim ────────────────────────────────────────
DELETE FROM claims WHERE claim_id = 4;
