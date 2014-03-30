CREATE INDEX desc_index ON radiology_record(description) INDEXTYPE IS CTXSYS.CONTEXT parameters ('sync (on commit)');
CREATE INDEX diag_index ON radiology_record(diagnosis) INDEXTYPE IS CTXSYS.CONTEXT parameters ('sync (on commit)');
CREATE INDEX fname_index ON persons(first_name) INDEXTYPE IS CTXSYS.CONTEXT parameters ('sync(on commit)');
CREATE INDEX lname_index ON persons(last_name) INDEXTYPE IS CTXSYS.CONTEXT parameters ('sync(on commit)');
CREATE INDEX time_index ON radiology_record(test_date);


DROP SEQUENCE image_id_seq;
DROP SEQUENCE record_id_seq;

CREATE SEQUENCE image_id_seq;
CREATE SEQUENCE record_id_seq;


-- Create default Administrator --
INSERT INTO users VALUES ('admin', 'admin', 'a', to_date('2013-04-07','YYYY-MM-DD'));
INSERT INTO persons VALUES ('admin', '', '', '', '', '');
