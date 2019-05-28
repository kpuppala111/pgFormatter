--
-- Hot Standby tests
--
-- hs_standby_disallowed.sql
--

SET transaction_read_only = OFF;

BEGIN TRANSACTION read write;
COMMIT;

-- SELECT
SELECT
    *
FROM
    hs1 FOR SHARE;

SELECT
    *
FROM
    hs1
FOR UPDATE;

-- DML
BEGIN;
INSERT INTO hs1
    VALUES (37);
ROLLBACK;

BEGIN;
DELETE FROM hs1
WHERE col1 = 1;
ROLLBACK;

BEGIN;
UPDATE
    hs1
SET
    col1 = NULL
WHERE
    col1 > 0;
ROLLBACK;

BEGIN;
TRUNCATE hs3;
ROLLBACK;

-- DDL
CREATE TEMPORARY TABLE hstemp1 (
    col1 integer
);

BEGIN;
DROP TABLE hs2;
ROLLBACK;

BEGIN;
CREATE TABLE hs4 (
    col1 integer
);
ROLLBACK;

-- Sequences
SELECT
    nextval('hsseq');

-- Two-phase commit transaction stuff
BEGIN;
SELECT
    count(*)
FROM
    hs1;
PREPARE TRANSACTION 'foobar';
ROLLBACK;

BEGIN;
SELECT
    count(*)
FROM
    hs1;
COMMIT PREPARED 'foobar';

ROLLBACK;

BEGIN;
SELECT
    count(*)
FROM
    hs1;
PREPARE TRANSACTION 'foobar';
ROLLBACK PREPARED 'foobar';

ROLLBACK;

BEGIN;
SELECT
    count(*)
FROM
    hs1;
ROLLBACK PREPARED 'foobar';

ROLLBACK;

-- Locks
BEGIN;
LOCK hs1;
COMMIT;

BEGIN;
LOCK hs1 IN SHARE
UPDATE
    EXCLUSIVE MODE;
COMMIT;

BEGIN;
LOCK hs1 IN SHARE MODE;
COMMIT;

BEGIN;
LOCK hs1 IN SHARE ROW EXCLUSIVE MODE;
COMMIT;

BEGIN;
LOCK hs1 IN EXCLUSIVE MODE;
COMMIT;

BEGIN;
LOCK hs1 IN ACCESS EXCLUSIVE MODE;
COMMIT;

-- Listen
LISTEN a;

NOTIFY a;

-- disallowed commands
ANALYZE hs1;

VACUUM hs2;

CLUSTER hs2
USING hs1_pkey;

REINDEX TABLE hs2;

REVOKE SELECT ON hs1
FROM
    PUBLIC;

GRANT SELECT ON hs1 TO PUBLIC;

