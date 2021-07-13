SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: test; Type: SCHEMA; Schema: -; Owner: postgres
--

---CREATE SCHEMA test;

CREATE EXTENSION pgcrypto WITH SCHEMA test;
ALTER SCHEMA test OWNER TO postgres;

--
-- Name: item_enum; Type: TYPE; Schema: test; Owner: postgres
--

CREATE TYPE test.item_enum AS ENUM (
    'RESOURCE_SERVER',
    'RESOURCE_GROUP',
    'RESOURCE'
);


ALTER TYPE test.item_enum OWNER TO postgres;

--
-- Name: policy_status_enum; Type: TYPE; Schema: test; Owner: postgres
--

CREATE TYPE test.policy_status_enum AS ENUM (
    'ACTIVE',
    'DELETED'
);


ALTER TYPE test.policy_status_enum OWNER TO postgres;

--
-- Name: role_enum; Type: TYPE; Schema: test; Owner: postgres
--

CREATE TYPE test.role_enum AS ENUM (
    'CONSUMER',
    'DELEGATE',
    'PROVIDER',
    'ADMIN'
);


ALTER TYPE test.role_enum OWNER TO postgres;

--
-- Name: role_status_enum; Type: TYPE; Schema: test; Owner: postgres
--

CREATE TYPE test.role_status_enum AS ENUM (
    'REJECTED',
    'PENDING',
    'APPROVED'
);


ALTER TYPE test.role_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: delegations; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.delegations (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    owner_id uuid NOT NULL,
    user_id uuid NOT NULL,
    resource_server_id uuid NOT NULL,
    status test.policy_status_enum NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.delegations OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.organizations (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    url character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.organizations OWNER TO postgres;

--
-- Name: policies; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.policies (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    item_id uuid NOT NULL,
    item_type test.item_enum NOT NULL,
    owner_id uuid NOT NULL,
    status test.policy_status_enum NOT NULL,
    expiry_time timestamp without time zone NOT NULL,
    constraints jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.policies OWNER TO postgres;

--
-- Name: resource; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.resource (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    cat_id character varying NOT NULL,
    provider_id uuid NOT NULL,
    resource_group_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    resource_server_id uuid NOT NULL
);


ALTER TABLE test.resource OWNER TO postgres;

--
-- Name: resource_group; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.resource_group (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    cat_id character varying NOT NULL,
    provider_id uuid NOT NULL,
    resource_server_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.resource_group OWNER TO postgres;

--
-- Name: resource_server; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.resource_server (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    owner_id uuid NOT NULL,
    url character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.resource_server OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.roles (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role test.role_enum NOT NULL,
    status test.role_status_enum NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.roles OWNER TO postgres;

--
-- Name: user_clients; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.user_clients (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    client_secret character varying NOT NULL,
    client_name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.user_clients OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: test; Owner: postgres
--

CREATE TABLE test.users (
    id uuid DEFAULT test.gen_random_uuid() NOT NULL,
    phone character varying(10) NOT NULL,
    organization_id uuid,
    email_hash character varying NOT NULL,
    keycloak_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE test.users OWNER TO postgres;

--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: policies policies_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.policies
    ADD CONSTRAINT policies_pkey PRIMARY KEY (id);


--
-- Name: resource_group resource_groups_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource_group
    ADD CONSTRAINT resource_groups_pkey PRIMARY KEY (id);


--
-- Name: resource_server resource_servers_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource_server
    ADD CONSTRAINT resource_servers_pkey PRIMARY KEY (id);


--
-- Name: resource resources_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: user_clients user_clients_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.user_clients
    ADD CONSTRAINT user_clients_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: delegations delegations_owner_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.delegations
    ADD CONSTRAINT delegations_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES test.users(id) ON DELETE CASCADE;


--
-- Name: delegations delegations_resource_server_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.delegations
    ADD CONSTRAINT delegations_resource_server_id_fkey FOREIGN KEY (resource_server_id) REFERENCES test.resource_server(id) ON DELETE CASCADE;


--
-- Name: delegations delegations_user_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.delegations
    ADD CONSTRAINT delegations_user_id_fkey FOREIGN KEY (user_id) REFERENCES test.users(id);


--
-- Name: policies policies_owner_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.policies
    ADD CONSTRAINT policies_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES test.users(id);


--
-- Name: policies policies_user_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.policies
    ADD CONSTRAINT policies_user_id_fkey FOREIGN KEY (user_id) REFERENCES test.users(id);


--
-- Name: resource_group resource_groups_provider_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource_group
    ADD CONSTRAINT resource_groups_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES test.users(id);


--
-- Name: resource_group resource_groups_resource_server_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource_group
    ADD CONSTRAINT resource_groups_resource_server_id_fkey FOREIGN KEY (resource_server_id) REFERENCES test.resource_server(id);


--
-- Name: resource resource_resource_server_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource
    ADD CONSTRAINT resource_resource_server_id_fkey FOREIGN KEY (resource_server_id) REFERENCES test.resource_server(id);


--
-- Name: resource_server resource_servers_owner_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource_server
    ADD CONSTRAINT resource_servers_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES test.users(id);


--
-- Name: resource resources_provider_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource
    ADD CONSTRAINT resources_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES test.users(id);


--
-- Name: resource resources_resource_group_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.resource
    ADD CONSTRAINT resources_resource_group_fkey FOREIGN KEY (resource_group_id) REFERENCES test.resource_group(id);


--
-- Name: roles roles_user_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.roles
    ADD CONSTRAINT roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES test.users(id) ON DELETE CASCADE;


--
-- Name: user_clients user_clients_user_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.user_clients
    ADD CONSTRAINT user_clients_user_id_fkey FOREIGN KEY (user_id) REFERENCES test.users(id) ON DELETE CASCADE;


--
-- Name: users users_organization_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY test.users
    ADD CONSTRAINT users_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES test.organizations(id);


--
-- Name: SCHEMA test; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA test TO auth;


--
-- Name: TABLE organizations; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE test.organizations TO auth;


--
-- Name: TABLE policies; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE test.policies TO auth;


--
-- Name: TABLE resource; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE test.resource TO auth;


--
-- Name: TABLE resource_group; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE test.resource_group TO auth;


--
-- Name: TABLE resource_server; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE test.resource_server TO auth;


--
-- Name: TABLE roles; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE test.roles TO auth;


--
-- Name: TABLE user_clients; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE test.user_clients TO auth;


--
-- Name: TABLE users; Type: ACL; Schema: test; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE test.users TO auth;


--
-- PostgreSQL database dump complete
--
