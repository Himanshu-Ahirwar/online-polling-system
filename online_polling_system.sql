
-- ============================================
-- DevifyX Assignment: Online Polling/Voting System
-- Author: Himanshu Ahirwar
-- Description: MySQL schema, sample data, and queries
-- ============================================

-- Drop if exists for safe re-run
DROP TABLE IF EXISTS vote;
DROP TABLE IF EXISTS poll_option;
DROP TABLE IF EXISTS poll;
DROP TABLE IF EXISTS user;

-- ============================================
-- TABLE: Users
-- ============================================
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: Polls
-- ============================================
CREATE TABLE poll (
    poll_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    expiration_date DATETIME NOT NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES user(user_id)
);

-- ============================================
-- TABLE: Poll Options
-- ============================================
CREATE TABLE poll_option (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    poll_id INT,
    option_text VARCHAR(255) NOT NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (poll_id) REFERENCES poll(poll_id)
);

-- ============================================
-- TABLE: Votes
-- ============================================
CREATE TABLE vote (
    vote_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    poll_id INT,
    option_id INT,
    voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_anonymous BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (poll_id) REFERENCES poll(poll_id),
    FOREIGN KEY (option_id) REFERENCES poll_option(option_id),
    UNIQUE (user_id, poll_id)
);

-- Indexes for performance
CREATE INDEX idx_poll_expiry ON poll(expiration_date);
CREATE INDEX idx_vote_time ON vote(voted_at);

-- ============================================
-- SAMPLE DATA
-- ============================================

-- Users
INSERT INTO user (username, email) VALUES 
('alice', 'alice@example.com'),
('bob', 'bob@example.com'),
('charlie', 'charlie@example.com');

-- Polls
INSERT INTO poll (title, description, expiration_date, created_by) VALUES 
('Best Programming Language', 'Vote your favorite language.', '2025-07-01 00:00:00', 1),
('Favorite Color', 'Pick your favorite color.', '2025-07-01 00:00:00', 2),
('Best Movie Genre', 'Choose a genre you love.', '2025-06-25 00:00:00', 3);

-- Poll Options (3 per poll)
INSERT INTO poll_option (poll_id, option_text) VALUES 
(1, 'Java'), (1, 'Python'), (1, 'C++'),
(2, 'Red'), (2, 'Blue'), (2, 'Green'),
(3, 'Action'), (3, 'Comedy'), (3, 'Horror');

-- Votes
INSERT INTO vote (user_id, poll_id, option_id, is_anonymous) VALUES 
(1, 1, 2, FALSE), (2, 1, 3, FALSE), (3, 1, 1, TRUE),
(1, 2, 5, FALSE), (2, 2, 6, TRUE), (3, 2, 5, FALSE),
(1, 3, 7, TRUE), (2, 3, 9, FALSE), (3, 3, 8, FALSE);

-- ============================================
-- CORE QUERIES
-- ============================================

-- Active Polls
SELECT * FROM poll WHERE expiration_date > NOW() AND is_deleted = FALSE;

-- Expired Polls
SELECT * FROM poll WHERE expiration_date <= NOW() AND is_deleted = FALSE;

-- Total Votes Per Poll
SELECT p.title, COUNT(v.vote_id) AS total_votes
FROM poll p
JOIN vote v ON p.poll_id = v.poll_id
GROUP BY p.poll_id;

-- Total Votes Per Option
SELECT po.option_text, COUNT(v.vote_id) AS vote_count
FROM poll_option po
LEFT JOIN vote v ON po.option_id = v.option_id
GROUP BY po.option_id;

-- Polls a User Voted In (example: user_id = 1)
SELECT DISTINCT p.title
FROM vote v
JOIN poll p ON v.poll_id = p.poll_id
WHERE v.user_id = 1;

-- ============================================
-- BONUS QUERIES
-- ============================================

-- Most Active Users
SELECT u.username, COUNT(*) AS total_votes
FROM vote v
JOIN user u ON v.user_id = u.user_id
GROUP BY u.user_id
ORDER BY total_votes DESC;

-- Trending Polls (last 24 hours)
SELECT p.title, COUNT(*) AS recent_votes
FROM poll p
JOIN vote v ON p.poll_id = v.poll_id
WHERE v.voted_at >= NOW() - INTERVAL 1 DAY
GROUP BY p.poll_id
ORDER BY recent_votes DESC;

-- Soft Deleted Polls
SELECT * FROM poll WHERE is_deleted = TRUE;
