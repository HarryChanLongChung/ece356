DROP TABLE IF EXISTS Post;
CREATE TABLE Posts (
  id INTEGER PRIMARY KEY autoincrement,
  name text NOT NULL,
  content text NOT NULL
);
