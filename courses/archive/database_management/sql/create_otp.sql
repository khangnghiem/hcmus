DROP SCHEMA IF EXISTS otp CASCADE;

CREATE SCHEMA IF NOT EXISTS otp;

CREATE OR REPLACE PROCEDURE create_otp_tables()
LANGUAGE plpgsql
AS $$
BEGIN
    CREATE TABLE IF NOT EXISTS otp.USER (
        id INT PRIMARY KEY,
        username VARCHAR(255),
        email VARCHAR(255),
        phone_num VARCHAR(20),
        password_hash VARCHAR(255),
        created_at TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS otp.USER_MFA_SETTINGS (
        id INT PRIMARY KEY,
        user_id INT,
        auth_method VARCHAR(255),
        is_enabled BOOLEAN,
        secret_key VARCHAR(255),
        created_at TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES otp.USER (id)
    );

    CREATE TABLE IF NOT EXISTS otp.TOTP_KEY (
        id INT PRIMARY KEY,
        user_mfa_settings_id INT,
        qr_code_uri VARCHAR(255),
        created_at TIMESTAMP,
        FOREIGN KEY (user_mfa_settings_id) REFERENCES otp.USER_MFA_SETTINGS (id)
    );

    CREATE TABLE IF NOT EXISTS otp.OTP_CODE (
        user_mfa_settings_id INT,
        otp_code VARCHAR(6),
        expires_at TIMESTAMP,
        FOREIGN KEY (user_mfa_settings_id) REFERENCES otp.USER_MFA_SETTINGS (id)
    );

    CREATE TABLE IF NOT EXISTS otp.MFA_LOG (
        id INT PRIMARY KEY,
        user_id INT,
        auth_method VARCHAR(255),
        status VARCHAR(50),
        created_at TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES otp.USER (id)
    );

    CREATE TABLE IF NOT EXISTS otp.TRUSTED_DEVICE (
        id INT PRIMARY KEY,
        user_id INT,
        device_info VARCHAR(255),
        device_token VARCHAR(255),
        last_used_at TIMESTAMP,
        expires_at TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES otp.USER (id)
    );

    CREATE TABLE IF NOT EXISTS otp.NOTIFICATION (
        id INT PRIMARY KEY,
        user_id INT,
        type VARCHAR(50),
        message TEXT,
        is_read BOOLEAN,
        created_at TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES otp.USER (id)
    );
END;
$$;


CREATE OR REPLACE PROCEDURE insert_sample_data()
LANGUAGE plpgsql
AS $$
DECLARE
    start_id INT;
BEGIN
    SELECT COALESCE(MAX(id), 0) + 1 INTO start_id FROM otp.USER;

    -- Sample data for otp.USER
    INSERT INTO otp.USER (id, username, email, phone_num, password_hash, created_at)
    SELECT start_id + i, 'user' || start_id + i, 'user' || start_id + i || '@example.com', LPAD((FLOOR(RANDOM() * 1000000000)::TEXT), 10, '0'), 'hash' || start_id + i, TO_TIMESTAMP('2023-01-' || LPAD((i + 1)::text, 2, '0') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    FROM generate_series(0, 9) AS s(i);

    -- Sample data for otp.USER_MFA_SETTINGS
    INSERT INTO otp.USER_MFA_SETTINGS (id, user_id, auth_method, is_enabled, secret_key, created_at)
    SELECT start_id + i, start_id + i, 'TOTP', TRUE, 'random_secret' || start_id + i, TO_TIMESTAMP('2023-01-' || LPAD((i + 1)::text, 2, '0') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    FROM generate_series(0, 9) AS s(i);

    -- Sample data for otp.TOTP_KEY
    INSERT INTO otp.TOTP_KEY (id, user_mfa_settings_id, qr_code_uri, created_at)
    SELECT start_id + i, start_id + i, 'random_uri' || start_id + i, TO_TIMESTAMP('2023-01-' || LPAD((i + 1)::text, 2, '0') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    FROM generate_series(0, 9) AS s(i);

    -- Sample data for otp.OTP_CODE
    INSERT INTO otp.OTP_CODE (user_mfa_settings_id, otp_code, expires_at)
    SELECT start_id + i, LPAD((654321 + start_id + i)::text, 6, '0'), TO_TIMESTAMP('2023-01-' || LPAD((i + 1)::text, 2, '0') || ' 00:10:00', 'YYYY-MM-DD HH24:MI:SS')
    FROM generate_series(0, 9) AS s(i);

    -- Sample data for otp.MFA_LOG
    INSERT INTO otp.MFA_LOG (id, user_id, auth_method, status, created_at)
    SELECT start_id + i, start_id + i, 'TOTP', 'FAILURE', TO_TIMESTAMP('2023-01-' || LPAD((i + 1)::text, 2, '0') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    FROM generate_series(0, 9) AS s(i);

    -- Sample data for otp.TRUSTED_DEVICE
    INSERT INTO otp.TRUSTED_DEVICE (id, user_id, device_info, device_token, last_used_at, expires_at)
    SELECT start_id + i, start_id + i, 'random_device' || start_id + i, 'random_token' || start_id + i, TO_TIMESTAMP('2023-01-' || LPAD((i + 1)::text, 2, '0') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-02-' || LPAD((i + 1)::text, 2, '0') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    FROM generate_series(0, 9) AS s(i);

    -- Sample data for otp.NOTIFICATION
    INSERT INTO otp.NOTIFICATION (id, user_id, type, message, is_read, created_at)
    SELECT start_id + i, start_id + i, 'sms', 'random_message' || start_id + i, TRUE, TO_TIMESTAMP('2023-01-' || LPAD((i + 1)::text, 2, '0') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    FROM generate_series(0, 9) AS s(i);
END;
$$;

CALL create_otp_tables();

DO $$
BEGIN
    FOR i IN 1..15 LOOP
        CALL insert_sample_data();
    END LOOP;
END $$;


