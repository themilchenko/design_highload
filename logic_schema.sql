create table if not exists users (
  id bigserial not null PRIMARY KEY,
  nickname varchar(32) not null unique,
  email varchar(128) not null unique,
  avatar vatchar(128) default null,
  description varchar(1024) default null,
  password varchar(128) not null,
  subsribers_num BIGINT default 0,
  subscriptions_num BIGINT default 0
);

CREATE TABLE IF NOT EXISTS sessions (
  value       varchar(60) primary key,
  user_id     bigserial not null references users (id) on delete cascade,
  expire_date date      not null
);

create table if not exists posts (
  id bigserial not null PRIMARY KEY,
  user_id bigserial not null references users(id) on delete cascade,
  media_data varchar(128) not null,
  description varchar(1024) default null,
  date_created timestamp not null default now(),
  likes_num BIGINT default 0,
  comments_num BIGINT default 0
);

create table if not exists likes (
  post_id bigserial not null references posts(id) on delete cascade,
  user_id bigserial not null references users(id) on delete cascade,
  PRIMARY KEY(post_id, user_id)
);

CREATE TABLE IF NOT EXISTS comments (
  id           bigserial     NOT NULL PRIMARY KEY,
  user_id      bigserial     NOT NULL REFERENCES users (id) ON DELETE NO ACTION,
  post_id      bigserial     NOT NULL REFERENCES posts (id) ON DELETE CASCADE,
  content      varchar(1024) NOT NULL,
  date_created TIMESTAMP     NOT NULL DEFAULT now()
);

create table if not exists subscriptions (
  creator_id bigserial not null references users(id) on delete cascade,
  follower_id bigserial not null references users(id) on delete cascade,
  PRIMARY KEY(creator_id, follower_id)
);
