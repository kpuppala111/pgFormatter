CREATE TABLE kbln (
    id integer NOT NULL,
    blank_series varchar(50) NOT NULL,
    company_id varchar(8)
)
PARTITION BY RANGE (id);

CREATE TABLE kbln_p0 OF kbln
FOR VALUES FROM (MINVALUE) TO (500000)
PARTITION BY HASH (blank_series);

CREATE TABLE kbln_p0_1 OF kbln_p0
FOR VALUES WITH (MODULUS 2, REMAINDER 0);

CREATE TABLE kbln_p0_2 OF kbln_p0
FOR VALUES WITH (MODULUS 2, REMAINDER 1);

