-- A few of the built-in system tables and views
SELECT * FROM v$version;
SELECT * FROM gv$locked_object;
SELECT * FROM v$session;
SELECT * FROM dba_objects;


-- A query to see the locks on the database
SELECT l.session_id||','||v.serial#  AS sid_serial,
       l.ORACLE_USERNAME ora_user,
       o.object_name, 
       o.object_type, 
       DECODE(l.locked_mode,
          0, 'None',
          1, 'Null',
          2, 'Row-S (SS)',
          3, 'Row-X (SX)',
          4, 'Share',
          5, 'S/Row-X (SSX)',
          6, 'Exclusive', 
          TO_CHAR(l.locked_mode)
       ) lock_mode,
       o.status, 
       to_char(o.last_ddl_time,'dd.mm.yy') last_ddl
FROM gv$locked_object l
  JOIN dba_objects o
     ON o.object_id = l.object_id
  JOIN v$session v
     ON v.sid = l.session_id
ORDER BY 2,3;



