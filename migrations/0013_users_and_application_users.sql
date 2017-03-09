-- +migrate Up
create table "user" (
	id bigserial primary key,
	created_at timestamp with time zone not null,
	updated_at timestamp with time zone not null,
	username character varying (100) not null,
	password_hash character varying (200) not null,
	session_ttl bigint not null,
	is_active boolean not null,
	is_admin boolean not null
);

create unique index idx_user_username on "user"(username);

create table application_user (
	id bigserial primary key,
	created_at timestamp with time zone not null,
	updated_at timestamp with time zone not null,
	user_id bigint not null,
	application_id bigint not null,
	is_admin boolean not null,

	unique(user_id, application_id)
);

create index idx_application_user_user_id on application_user(user_id);
create index idx_application_user_application_id on application_user(application_id);

-- global admin (password: admin)
insert into "user" (
	created_at,
	updated_at,
	username,
	password_hash,
	session_ttl,
	is_active,
	is_admin
) values (
	now(),
	now(),
	'admin',
	'PBKDF2$sha512$1048576$RAq/B/qohf1SuHHMx+wX5Q==$mfmhCypZoUW8uekm+HuOHRnB0ZUQrmTVcNYyhmFtrXfLIQERw1qigBJNFvT317BfijSmBM0UG53G1Ovx+W/HQA==',
	0,
	true,
	true
);


-- +migrate Down
drop index idx_application_user_application_id;
drop index idx_application_user_user_id;
drop table application_user;

drop index idx_user_username;
drop table "user";
