--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO username;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO username;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO username;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO username;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO username;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO username;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO username;

--
-- Name: client; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO username;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO username;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO username;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO username;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO username;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO username;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO username;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO username;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO username;

--
-- Name: component; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO username;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO username;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO username;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO username;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO username;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO username;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO username;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO username;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO username;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO username;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO username;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO username;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO username;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO username;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO username;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO username;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO username;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO username;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO username;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL,
    organization_id character varying(255),
    hide_on_login boolean DEFAULT false
);


ALTER TABLE public.identity_provider OWNER TO username;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO username;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO username;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO username;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.keycloak_group OWNER TO username;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO username;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO username;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO username;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO username;

--
-- Name: org; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO username;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO username;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO username;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO username;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO username;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO username;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO username;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO username;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO username;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO username;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO username;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO username;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO username;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO username;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO username;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO username;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO username;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO username;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO username;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO username;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO username;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO username;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO username;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO username;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO username;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO username;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO username;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO username;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO username;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO username;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO username;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO username;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO username;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO username;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO username;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO username;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO username;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO username;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO username;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO username;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO username;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO username;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: username
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO username;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
2b2e1b20-899c-4556-9cab-0466997ec474	\N	auth-cookie	8fb72edd-3595-407b-9597-900a93b73829	887797d9-b772-43fe-83e0-3fbc9e17a100	2	10	f	\N	\N
550972b2-2d09-4322-b87f-5d93e03d9b88	\N	auth-spnego	8fb72edd-3595-407b-9597-900a93b73829	887797d9-b772-43fe-83e0-3fbc9e17a100	3	20	f	\N	\N
9be4d1c9-ad5f-4017-9d1c-6c503d7a69e8	\N	identity-provider-redirector	8fb72edd-3595-407b-9597-900a93b73829	887797d9-b772-43fe-83e0-3fbc9e17a100	2	25	f	\N	\N
4531b66e-a256-487c-adaa-c313acce3e8e	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	887797d9-b772-43fe-83e0-3fbc9e17a100	2	30	t	1227e041-7ab5-446e-be7c-311726f6fb78	\N
e964677b-26ba-496b-956c-93841d257bf6	\N	auth-username-password-form	8fb72edd-3595-407b-9597-900a93b73829	1227e041-7ab5-446e-be7c-311726f6fb78	0	10	f	\N	\N
2e825a29-9b08-4456-a8bb-4ac49aa9ce1e	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	1227e041-7ab5-446e-be7c-311726f6fb78	1	20	t	e4b7c418-e8b8-412f-8e19-5e2fbcddc698	\N
300de8f8-3252-4608-8d15-7b6c77f1bfed	\N	conditional-user-configured	8fb72edd-3595-407b-9597-900a93b73829	e4b7c418-e8b8-412f-8e19-5e2fbcddc698	0	10	f	\N	\N
0a504038-f911-491a-ba2f-5667f1c59f06	\N	auth-otp-form	8fb72edd-3595-407b-9597-900a93b73829	e4b7c418-e8b8-412f-8e19-5e2fbcddc698	0	20	f	\N	\N
49ce2cc9-014c-4a79-8245-0cac0a25ca71	\N	direct-grant-validate-username	8fb72edd-3595-407b-9597-900a93b73829	e4d9cd76-1b2e-4a11-95fb-c3cfeb35290a	0	10	f	\N	\N
10adba06-ad7e-4b53-854b-3dbdf1292474	\N	direct-grant-validate-password	8fb72edd-3595-407b-9597-900a93b73829	e4d9cd76-1b2e-4a11-95fb-c3cfeb35290a	0	20	f	\N	\N
70ed6ba0-150f-47b3-9815-fb08769efdce	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	e4d9cd76-1b2e-4a11-95fb-c3cfeb35290a	1	30	t	02892a8d-fce4-44b8-98d5-7b00bd1297db	\N
d7f48156-ecb5-40b3-9c83-d003ee9269ea	\N	conditional-user-configured	8fb72edd-3595-407b-9597-900a93b73829	02892a8d-fce4-44b8-98d5-7b00bd1297db	0	10	f	\N	\N
39477609-b476-49a7-897b-675ffba9a23d	\N	direct-grant-validate-otp	8fb72edd-3595-407b-9597-900a93b73829	02892a8d-fce4-44b8-98d5-7b00bd1297db	0	20	f	\N	\N
019617ed-2f71-42a8-9dfe-c499e402ae02	\N	registration-page-form	8fb72edd-3595-407b-9597-900a93b73829	7cecc287-334b-4c89-974a-901b8dba445b	0	10	t	b6710b70-5347-43f6-9e43-ed0d779994b3	\N
b25d4734-575e-45e8-8341-1133d7b637ee	\N	registration-user-creation	8fb72edd-3595-407b-9597-900a93b73829	b6710b70-5347-43f6-9e43-ed0d779994b3	0	20	f	\N	\N
29849f97-5cfc-445d-bd7b-b95bdf1c519f	\N	registration-password-action	8fb72edd-3595-407b-9597-900a93b73829	b6710b70-5347-43f6-9e43-ed0d779994b3	0	50	f	\N	\N
52fc46b2-4a96-4939-85e3-47b65de6956f	\N	registration-recaptcha-action	8fb72edd-3595-407b-9597-900a93b73829	b6710b70-5347-43f6-9e43-ed0d779994b3	3	60	f	\N	\N
9e18416c-97b2-4159-a335-a6df86749279	\N	registration-terms-and-conditions	8fb72edd-3595-407b-9597-900a93b73829	b6710b70-5347-43f6-9e43-ed0d779994b3	3	70	f	\N	\N
9943a014-3db9-4471-8f32-fe428460d453	\N	reset-credentials-choose-user	8fb72edd-3595-407b-9597-900a93b73829	d1155f76-b750-49c1-90ae-7e79bef97329	0	10	f	\N	\N
8af29d5b-55c1-4902-acb1-fe32aed9ae76	\N	reset-credential-email	8fb72edd-3595-407b-9597-900a93b73829	d1155f76-b750-49c1-90ae-7e79bef97329	0	20	f	\N	\N
e5121e86-1acb-4e30-a85e-387cef49b45d	\N	reset-password	8fb72edd-3595-407b-9597-900a93b73829	d1155f76-b750-49c1-90ae-7e79bef97329	0	30	f	\N	\N
fd455556-3839-4f96-8b3c-a3fe544d6095	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	d1155f76-b750-49c1-90ae-7e79bef97329	1	40	t	0f8a512f-e25e-4a34-b572-18e919bf5ccd	\N
658304e1-6444-49da-a607-1518f7771d04	\N	conditional-user-configured	8fb72edd-3595-407b-9597-900a93b73829	0f8a512f-e25e-4a34-b572-18e919bf5ccd	0	10	f	\N	\N
371bd338-ab70-49f0-baa7-e0fd3a810927	\N	reset-otp	8fb72edd-3595-407b-9597-900a93b73829	0f8a512f-e25e-4a34-b572-18e919bf5ccd	0	20	f	\N	\N
9159b6de-b3f0-455c-bad5-b7b59d4ba1c0	\N	client-secret	8fb72edd-3595-407b-9597-900a93b73829	61fbec52-eb6c-4bb6-ac14-10f8d6c2d77c	2	10	f	\N	\N
a73e5ac4-8b35-4bcd-acb8-7cf70acf2d59	\N	client-jwt	8fb72edd-3595-407b-9597-900a93b73829	61fbec52-eb6c-4bb6-ac14-10f8d6c2d77c	2	20	f	\N	\N
56e18f3f-c4e3-40db-b499-a5298adf6182	\N	client-secret-jwt	8fb72edd-3595-407b-9597-900a93b73829	61fbec52-eb6c-4bb6-ac14-10f8d6c2d77c	2	30	f	\N	\N
c0e7692d-d571-4fa6-acdf-dfef0f81d176	\N	client-x509	8fb72edd-3595-407b-9597-900a93b73829	61fbec52-eb6c-4bb6-ac14-10f8d6c2d77c	2	40	f	\N	\N
afbc5cb0-d11a-4d9a-8fa0-fd6024097168	\N	idp-review-profile	8fb72edd-3595-407b-9597-900a93b73829	ff774387-2d49-45e5-8176-3a3eff4932ba	0	10	f	\N	31b457cc-039b-4fae-a260-a54c83fafb85
5f2cbd09-941f-4824-b1af-8c34eddf5b90	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	ff774387-2d49-45e5-8176-3a3eff4932ba	0	20	t	8790611c-ae54-41b7-a374-8b3897de7472	\N
c48780bb-1fd1-475d-9a3a-0579dea21b55	\N	idp-create-user-if-unique	8fb72edd-3595-407b-9597-900a93b73829	8790611c-ae54-41b7-a374-8b3897de7472	2	10	f	\N	d794793a-ebb4-4b66-a65a-2ed33c719058
675c31fd-47de-4ded-be88-211d3db226c0	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	8790611c-ae54-41b7-a374-8b3897de7472	2	20	t	37bb88a1-e33f-4cc5-bec2-3ff032ed7bb4	\N
672605f4-bdca-40a9-b59b-5a3561c2c978	\N	idp-confirm-link	8fb72edd-3595-407b-9597-900a93b73829	37bb88a1-e33f-4cc5-bec2-3ff032ed7bb4	0	10	f	\N	\N
be1cf2b1-4293-4593-9e4a-08ff9640d51b	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	37bb88a1-e33f-4cc5-bec2-3ff032ed7bb4	0	20	t	c847bbf4-3f25-45b1-a55c-560fb65809c5	\N
7a910cb4-5136-4c84-87b3-9f1b64181f32	\N	idp-email-verification	8fb72edd-3595-407b-9597-900a93b73829	c847bbf4-3f25-45b1-a55c-560fb65809c5	2	10	f	\N	\N
f4f37536-9da4-4870-8765-33765e7caa48	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	c847bbf4-3f25-45b1-a55c-560fb65809c5	2	20	t	d764198e-603a-488e-9d38-9d59ba206ee0	\N
3b1e3f8f-0fd8-4567-8a57-c9eed31fc012	\N	idp-username-password-form	8fb72edd-3595-407b-9597-900a93b73829	d764198e-603a-488e-9d38-9d59ba206ee0	0	10	f	\N	\N
dfa4c901-cd06-429d-843e-7eb6c5cad702	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	d764198e-603a-488e-9d38-9d59ba206ee0	1	20	t	5afe5e4b-fc29-41a8-95a1-bb93967bb9bc	\N
ea58c82a-2ef4-4b36-93cf-03411cec4c62	\N	conditional-user-configured	8fb72edd-3595-407b-9597-900a93b73829	5afe5e4b-fc29-41a8-95a1-bb93967bb9bc	0	10	f	\N	\N
6d1f8d67-47c3-4761-af1a-7a7acf4e87e8	\N	auth-otp-form	8fb72edd-3595-407b-9597-900a93b73829	5afe5e4b-fc29-41a8-95a1-bb93967bb9bc	0	20	f	\N	\N
b508cab3-5c11-42ad-84e7-6eccab55236a	\N	http-basic-authenticator	8fb72edd-3595-407b-9597-900a93b73829	8e6ace71-09b8-4261-92ee-e97219c602b1	0	10	f	\N	\N
54d0377b-75a4-4c1a-918e-d4698504a59b	\N	docker-http-basic-authenticator	8fb72edd-3595-407b-9597-900a93b73829	68b7499c-7a18-4af3-88c0-7bbfad1a66d1	0	10	f	\N	\N
45f1bea9-7771-4203-bf8d-b67903757058	\N	auth-cookie	106128c4-abe4-410c-82af-b8d094c1c313	24170321-3ffd-49b1-96e7-8f9e7292df0f	2	10	f	\N	\N
9843e893-2a02-4589-a3a2-247022d596e5	\N	auth-spnego	106128c4-abe4-410c-82af-b8d094c1c313	24170321-3ffd-49b1-96e7-8f9e7292df0f	3	20	f	\N	\N
c5f6421f-328b-44c9-9b4e-0470e6ee8115	\N	identity-provider-redirector	106128c4-abe4-410c-82af-b8d094c1c313	24170321-3ffd-49b1-96e7-8f9e7292df0f	2	25	f	\N	\N
4da391ae-8977-4d5c-b6b8-dde4e0f73f5e	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	24170321-3ffd-49b1-96e7-8f9e7292df0f	2	30	t	f8b37d9c-b17d-4fec-ac03-aae8263764e6	\N
ec4c225c-5649-48ed-8d96-e4d6ea002a6a	\N	auth-username-password-form	106128c4-abe4-410c-82af-b8d094c1c313	f8b37d9c-b17d-4fec-ac03-aae8263764e6	0	10	f	\N	\N
a6082509-93b2-41f4-9040-d1e30aeb0f19	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	f8b37d9c-b17d-4fec-ac03-aae8263764e6	1	20	t	04e40dc3-e96d-4bf0-b5cc-5a16767d8411	\N
0a83ee2c-6c7c-44f8-834e-eb21d93498cd	\N	conditional-user-configured	106128c4-abe4-410c-82af-b8d094c1c313	04e40dc3-e96d-4bf0-b5cc-5a16767d8411	0	10	f	\N	\N
6bca3e29-9826-4b3d-a7b2-b121490e23fe	\N	auth-otp-form	106128c4-abe4-410c-82af-b8d094c1c313	04e40dc3-e96d-4bf0-b5cc-5a16767d8411	0	20	f	\N	\N
5a856c62-4d02-4271-a56c-60ab648365bc	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	24170321-3ffd-49b1-96e7-8f9e7292df0f	2	26	t	c6a6c620-9b42-4c26-a7b1-04b594c73bba	\N
36973299-f8db-4bed-865f-12e15dc76e66	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	c6a6c620-9b42-4c26-a7b1-04b594c73bba	1	10	t	057ea04d-f6ed-4c4e-8e29-258c72118a08	\N
ef67a25d-85cd-47e1-b866-13dd3acf81b7	\N	conditional-user-configured	106128c4-abe4-410c-82af-b8d094c1c313	057ea04d-f6ed-4c4e-8e29-258c72118a08	0	10	f	\N	\N
b565f87e-5eac-4d16-bbd0-fd40a3f9eabc	\N	organization	106128c4-abe4-410c-82af-b8d094c1c313	057ea04d-f6ed-4c4e-8e29-258c72118a08	2	20	f	\N	\N
c08c7e2d-92f8-4810-b67d-9ad5d5415a64	\N	direct-grant-validate-username	106128c4-abe4-410c-82af-b8d094c1c313	22de8b5b-2c75-45c3-8963-23154813cc53	0	10	f	\N	\N
43761e27-198a-4e9f-9c11-848c9358940f	\N	direct-grant-validate-password	106128c4-abe4-410c-82af-b8d094c1c313	22de8b5b-2c75-45c3-8963-23154813cc53	0	20	f	\N	\N
c7cc5ef5-d5fa-4e8b-b888-cf551f27f2fc	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	22de8b5b-2c75-45c3-8963-23154813cc53	1	30	t	abc04d8f-f1cf-4d5e-a1dd-cbd5118f3685	\N
9112673e-54e4-4505-9bc5-45d1ae2b65f7	\N	conditional-user-configured	106128c4-abe4-410c-82af-b8d094c1c313	abc04d8f-f1cf-4d5e-a1dd-cbd5118f3685	0	10	f	\N	\N
58b204c3-5fbf-49b4-9693-09e681c63a4f	\N	direct-grant-validate-otp	106128c4-abe4-410c-82af-b8d094c1c313	abc04d8f-f1cf-4d5e-a1dd-cbd5118f3685	0	20	f	\N	\N
ba9d0e9c-ec5c-4bed-b12e-9f2b18400ec4	\N	registration-page-form	106128c4-abe4-410c-82af-b8d094c1c313	58b06581-f5e1-411a-b621-ae5517361576	0	10	t	3f1999b2-4d98-4ccb-bd1e-64192dd7074c	\N
126f047c-751e-47ba-84d6-852726d5f997	\N	registration-user-creation	106128c4-abe4-410c-82af-b8d094c1c313	3f1999b2-4d98-4ccb-bd1e-64192dd7074c	0	20	f	\N	\N
cd01a72a-8ab0-4bd9-9347-b9383cd38459	\N	registration-password-action	106128c4-abe4-410c-82af-b8d094c1c313	3f1999b2-4d98-4ccb-bd1e-64192dd7074c	0	50	f	\N	\N
2f10c3c7-618c-4204-8fae-c769d053357b	\N	registration-recaptcha-action	106128c4-abe4-410c-82af-b8d094c1c313	3f1999b2-4d98-4ccb-bd1e-64192dd7074c	3	60	f	\N	\N
83876955-727c-4114-8d5a-eec79e860727	\N	registration-terms-and-conditions	106128c4-abe4-410c-82af-b8d094c1c313	3f1999b2-4d98-4ccb-bd1e-64192dd7074c	3	70	f	\N	\N
f993584b-8bf7-4ddb-b1bd-f3a74044a32c	\N	reset-credentials-choose-user	106128c4-abe4-410c-82af-b8d094c1c313	ce3effbe-bd6b-480f-875c-54b35437e920	0	10	f	\N	\N
edeb1523-e551-4e1c-aa9f-93a28ca98ebb	\N	reset-credential-email	106128c4-abe4-410c-82af-b8d094c1c313	ce3effbe-bd6b-480f-875c-54b35437e920	0	20	f	\N	\N
1c9eae0a-66e9-4e27-941d-fda6117bce1e	\N	reset-password	106128c4-abe4-410c-82af-b8d094c1c313	ce3effbe-bd6b-480f-875c-54b35437e920	0	30	f	\N	\N
0be994cd-b689-4aee-9da2-71e1fe5897a9	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	ce3effbe-bd6b-480f-875c-54b35437e920	1	40	t	e54c7797-cd70-4580-8ddd-4239be938c60	\N
9dbdcd98-fb3e-4478-a9af-d47c4c0cc34c	\N	conditional-user-configured	106128c4-abe4-410c-82af-b8d094c1c313	e54c7797-cd70-4580-8ddd-4239be938c60	0	10	f	\N	\N
a23fa1f5-95bf-450c-8a4c-38febc05589f	\N	reset-otp	106128c4-abe4-410c-82af-b8d094c1c313	e54c7797-cd70-4580-8ddd-4239be938c60	0	20	f	\N	\N
1d1a8ea2-7305-4bf7-b3c8-264c1e80584b	\N	client-secret	106128c4-abe4-410c-82af-b8d094c1c313	428a0777-6b4e-42e7-b116-c5e5393d3c91	2	10	f	\N	\N
ba28ff8c-6f42-45d9-8525-2c77407a00a9	\N	client-jwt	106128c4-abe4-410c-82af-b8d094c1c313	428a0777-6b4e-42e7-b116-c5e5393d3c91	2	20	f	\N	\N
1be8c389-c3f5-4cac-86c2-92208ffb88dc	\N	client-secret-jwt	106128c4-abe4-410c-82af-b8d094c1c313	428a0777-6b4e-42e7-b116-c5e5393d3c91	2	30	f	\N	\N
cc9c469f-234d-4d83-91b0-345668afa9a3	\N	client-x509	106128c4-abe4-410c-82af-b8d094c1c313	428a0777-6b4e-42e7-b116-c5e5393d3c91	2	40	f	\N	\N
8549afe9-179f-412e-82b0-6db0a29e3453	\N	idp-review-profile	106128c4-abe4-410c-82af-b8d094c1c313	3dd3d088-0751-4b91-bfb8-bb8abf19b8d2	0	10	f	\N	0b5ca501-c341-433e-ab12-aa240442849e
e300f16f-c454-410c-885f-906add304a52	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	3dd3d088-0751-4b91-bfb8-bb8abf19b8d2	0	20	t	c46cd20a-ef1c-4073-8f1a-fbe4a8a4ae08	\N
3cd1d4b0-f7d1-4bdb-88df-ffdf2f383230	\N	idp-create-user-if-unique	106128c4-abe4-410c-82af-b8d094c1c313	c46cd20a-ef1c-4073-8f1a-fbe4a8a4ae08	2	10	f	\N	a138fa7d-95ab-43ac-870d-b59930ed5a36
49300fb7-fd8a-4790-bb27-7022f05e33b3	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	c46cd20a-ef1c-4073-8f1a-fbe4a8a4ae08	2	20	t	4cde688c-5bd3-41e5-805e-e22a7ec2f264	\N
0767f385-7b26-438b-a59d-a408590a1201	\N	idp-confirm-link	106128c4-abe4-410c-82af-b8d094c1c313	4cde688c-5bd3-41e5-805e-e22a7ec2f264	0	10	f	\N	\N
b47f233a-f4a6-448c-a08b-171fa7ee1318	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	4cde688c-5bd3-41e5-805e-e22a7ec2f264	0	20	t	7f1976c7-162f-4a99-b9fe-8702b2a74fbd	\N
0ca480a7-9c49-49f8-8f3c-80021b44333f	\N	idp-email-verification	106128c4-abe4-410c-82af-b8d094c1c313	7f1976c7-162f-4a99-b9fe-8702b2a74fbd	2	10	f	\N	\N
e7defecc-581b-4d3d-a17b-d13206a973f0	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	7f1976c7-162f-4a99-b9fe-8702b2a74fbd	2	20	t	8f58f38f-63d3-493d-b52c-682b090906ee	\N
079d8626-df11-47f7-9088-268ce254b843	\N	idp-username-password-form	106128c4-abe4-410c-82af-b8d094c1c313	8f58f38f-63d3-493d-b52c-682b090906ee	0	10	f	\N	\N
faa71fe2-6d71-46d0-904a-cbdabfd92679	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	8f58f38f-63d3-493d-b52c-682b090906ee	1	20	t	63c5d27b-1516-4bce-b132-eec2bb20ca9c	\N
8835cd03-0a12-4b15-ac99-e1f518eb78a1	\N	conditional-user-configured	106128c4-abe4-410c-82af-b8d094c1c313	63c5d27b-1516-4bce-b132-eec2bb20ca9c	0	10	f	\N	\N
3a5a92ba-89f3-4051-8567-4b7bcf0b2bb6	\N	auth-otp-form	106128c4-abe4-410c-82af-b8d094c1c313	63c5d27b-1516-4bce-b132-eec2bb20ca9c	0	20	f	\N	\N
96cb6ffd-5c3f-4836-8df3-1df29fcabed5	\N	\N	106128c4-abe4-410c-82af-b8d094c1c313	3dd3d088-0751-4b91-bfb8-bb8abf19b8d2	1	50	t	a5c08895-2155-4ab4-8249-b239ee7d308a	\N
f22dc297-f923-438e-910e-0a500a6acb4c	\N	conditional-user-configured	106128c4-abe4-410c-82af-b8d094c1c313	a5c08895-2155-4ab4-8249-b239ee7d308a	0	10	f	\N	\N
e83fecbe-7975-429b-ada8-f14eb46334a1	\N	idp-add-organization-member	106128c4-abe4-410c-82af-b8d094c1c313	a5c08895-2155-4ab4-8249-b239ee7d308a	0	20	f	\N	\N
c0f2626b-1fac-41ee-a17c-08fd87ce515f	\N	http-basic-authenticator	106128c4-abe4-410c-82af-b8d094c1c313	3716195e-2c69-4544-b349-b64e70ac446b	0	10	f	\N	\N
51de2516-add4-4b6f-9667-24320aa684e3	\N	docker-http-basic-authenticator	106128c4-abe4-410c-82af-b8d094c1c313	5955cd49-a492-48ef-a681-bddacefcd0b5	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
887797d9-b772-43fe-83e0-3fbc9e17a100	browser	Browser based authentication	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	t	t
1227e041-7ab5-446e-be7c-311726f6fb78	forms	Username, password, otp and other auth forms.	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
e4b7c418-e8b8-412f-8e19-5e2fbcddc698	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
e4d9cd76-1b2e-4a11-95fb-c3cfeb35290a	direct grant	OpenID Connect Resource Owner Grant	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	t	t
02892a8d-fce4-44b8-98d5-7b00bd1297db	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
7cecc287-334b-4c89-974a-901b8dba445b	registration	Registration flow	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	t	t
b6710b70-5347-43f6-9e43-ed0d779994b3	registration form	Registration form	8fb72edd-3595-407b-9597-900a93b73829	form-flow	f	t
d1155f76-b750-49c1-90ae-7e79bef97329	reset credentials	Reset credentials for a user if they forgot their password or something	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	t	t
0f8a512f-e25e-4a34-b572-18e919bf5ccd	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
61fbec52-eb6c-4bb6-ac14-10f8d6c2d77c	clients	Base authentication for clients	8fb72edd-3595-407b-9597-900a93b73829	client-flow	t	t
ff774387-2d49-45e5-8176-3a3eff4932ba	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	t	t
8790611c-ae54-41b7-a374-8b3897de7472	User creation or linking	Flow for the existing/non-existing user alternatives	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
37bb88a1-e33f-4cc5-bec2-3ff032ed7bb4	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
c847bbf4-3f25-45b1-a55c-560fb65809c5	Account verification options	Method with which to verity the existing account	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
d764198e-603a-488e-9d38-9d59ba206ee0	Verify Existing Account by Re-authentication	Reauthentication of existing account	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
5afe5e4b-fc29-41a8-95a1-bb93967bb9bc	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	f	t
8e6ace71-09b8-4261-92ee-e97219c602b1	saml ecp	SAML ECP Profile Authentication Flow	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	t	t
68b7499c-7a18-4af3-88c0-7bbfad1a66d1	docker auth	Used by Docker clients to authenticate against the IDP	8fb72edd-3595-407b-9597-900a93b73829	basic-flow	t	t
24170321-3ffd-49b1-96e7-8f9e7292df0f	browser	Browser based authentication	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	t	t
f8b37d9c-b17d-4fec-ac03-aae8263764e6	forms	Username, password, otp and other auth forms.	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
04e40dc3-e96d-4bf0-b5cc-5a16767d8411	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
c6a6c620-9b42-4c26-a7b1-04b594c73bba	Organization	\N	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
057ea04d-f6ed-4c4e-8e29-258c72118a08	Browser - Conditional Organization	Flow to determine if the organization identity-first login is to be used	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
22de8b5b-2c75-45c3-8963-23154813cc53	direct grant	OpenID Connect Resource Owner Grant	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	t	t
abc04d8f-f1cf-4d5e-a1dd-cbd5118f3685	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
58b06581-f5e1-411a-b621-ae5517361576	registration	Registration flow	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	t	t
3f1999b2-4d98-4ccb-bd1e-64192dd7074c	registration form	Registration form	106128c4-abe4-410c-82af-b8d094c1c313	form-flow	f	t
ce3effbe-bd6b-480f-875c-54b35437e920	reset credentials	Reset credentials for a user if they forgot their password or something	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	t	t
e54c7797-cd70-4580-8ddd-4239be938c60	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
428a0777-6b4e-42e7-b116-c5e5393d3c91	clients	Base authentication for clients	106128c4-abe4-410c-82af-b8d094c1c313	client-flow	t	t
3dd3d088-0751-4b91-bfb8-bb8abf19b8d2	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	t	t
c46cd20a-ef1c-4073-8f1a-fbe4a8a4ae08	User creation or linking	Flow for the existing/non-existing user alternatives	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
4cde688c-5bd3-41e5-805e-e22a7ec2f264	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
7f1976c7-162f-4a99-b9fe-8702b2a74fbd	Account verification options	Method with which to verity the existing account	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
8f58f38f-63d3-493d-b52c-682b090906ee	Verify Existing Account by Re-authentication	Reauthentication of existing account	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
63c5d27b-1516-4bce-b132-eec2bb20ca9c	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
a5c08895-2155-4ab4-8249-b239ee7d308a	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	f	t
3716195e-2c69-4544-b349-b64e70ac446b	saml ecp	SAML ECP Profile Authentication Flow	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	t	t
5955cd49-a492-48ef-a681-bddacefcd0b5	docker auth	Used by Docker clients to authenticate against the IDP	106128c4-abe4-410c-82af-b8d094c1c313	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
31b457cc-039b-4fae-a260-a54c83fafb85	review profile config	8fb72edd-3595-407b-9597-900a93b73829
d794793a-ebb4-4b66-a65a-2ed33c719058	create unique user config	8fb72edd-3595-407b-9597-900a93b73829
0b5ca501-c341-433e-ab12-aa240442849e	review profile config	106128c4-abe4-410c-82af-b8d094c1c313
a138fa7d-95ab-43ac-870d-b59930ed5a36	create unique user config	106128c4-abe4-410c-82af-b8d094c1c313
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
31b457cc-039b-4fae-a260-a54c83fafb85	missing	update.profile.on.first.login
d794793a-ebb4-4b66-a65a-2ed33c719058	false	require.password.update.after.registration
0b5ca501-c341-433e-ab12-aa240442849e	missing	update.profile.on.first.login
a138fa7d-95ab-43ac-870d-b59930ed5a36	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	f	master-realm	0	f	\N	\N	t	\N	f	8fb72edd-3595-407b-9597-900a93b73829	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
e58cdd2a-c86d-4477-9182-8d2448818975	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	8fb72edd-3595-407b-9597-900a93b73829	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
a1009637-d602-4178-8531-be4cd5eddbdd	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	8fb72edd-3595-407b-9597-900a93b73829	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	t	f	broker	0	f	\N	\N	t	\N	f	8fb72edd-3595-407b-9597-900a93b73829	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
83e64015-a218-4024-8318-fb3ffe674c30	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	8fb72edd-3595-407b-9597-900a93b73829	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
2949de44-3c2a-4943-a0be-817417e271a2	t	t	admin-cli	0	t	\N	\N	f	\N	f	8fb72edd-3595-407b-9597-900a93b73829	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
f17d49e1-1994-4c2a-9130-3e0353fabc06	t	f	FdoTestbed-realm	0	f	\N	\N	t	\N	f	8fb72edd-3595-407b-9597-900a93b73829	\N	0	f	f	FdoTestbed Realm	f	client-secret	\N	\N	\N	t	f	f	f
6c5705d3-5e1e-4931-b897-d954d6da7b05	t	f	realm-management	0	f	\N	\N	t	\N	f	106128c4-abe4-410c-82af-b8d094c1c313	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
22a1d428-ec7b-4f91-a222-06c55a128831	t	f	account	0	t	\N	/realms/FdoTestbed/account/	f	\N	f	106128c4-abe4-410c-82af-b8d094c1c313	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
1ef61626-bfd6-4c61-ba3c-e93a688b330f	t	f	account-console	0	t	\N	/realms/FdoTestbed/account/	f	\N	f	106128c4-abe4-410c-82af-b8d094c1c313	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
7eed5789-b554-45ae-b162-5f68d136ff21	t	f	broker	0	f	\N	\N	t	\N	f	106128c4-abe4-410c-82af-b8d094c1c313	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
0e9e2341-b009-4953-808d-0492c93c809d	t	t	security-admin-console	0	t	\N	/admin/FdoTestbed/console/	f	\N	f	106128c4-abe4-410c-82af-b8d094c1c313	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
e38c9b0b-4236-42e1-a8bc-fcc54315a449	t	t	admin-cli	0	t	\N	\N	f	\N	f	106128c4-abe4-410c-82af-b8d094c1c313	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
5ad6ff62-dcfe-479b-b323-cd560f4a7799	t	t	fdo-manager	0	f	b3g6hmrp1BeOohUMaeeuV6gJs1F5ysOq	http://localhost:8000/	f		f	106128c4-abe4-410c-82af-b8d094c1c313	openid-connect	-1	t	f	FDO Manager	f	client-secret	http://localhost:8000/		\N	t	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
e58cdd2a-c86d-4477-9182-8d2448818975	post.logout.redirect.uris	+
a1009637-d602-4178-8531-be4cd5eddbdd	post.logout.redirect.uris	+
a1009637-d602-4178-8531-be4cd5eddbdd	pkce.code.challenge.method	S256
83e64015-a218-4024-8318-fb3ffe674c30	post.logout.redirect.uris	+
83e64015-a218-4024-8318-fb3ffe674c30	pkce.code.challenge.method	S256
83e64015-a218-4024-8318-fb3ffe674c30	client.use.lightweight.access.token.enabled	true
2949de44-3c2a-4943-a0be-817417e271a2	client.use.lightweight.access.token.enabled	true
22a1d428-ec7b-4f91-a222-06c55a128831	post.logout.redirect.uris	+
1ef61626-bfd6-4c61-ba3c-e93a688b330f	post.logout.redirect.uris	+
1ef61626-bfd6-4c61-ba3c-e93a688b330f	pkce.code.challenge.method	S256
0e9e2341-b009-4953-808d-0492c93c809d	post.logout.redirect.uris	+
0e9e2341-b009-4953-808d-0492c93c809d	pkce.code.challenge.method	S256
0e9e2341-b009-4953-808d-0492c93c809d	client.use.lightweight.access.token.enabled	true
e38c9b0b-4236-42e1-a8bc-fcc54315a449	client.use.lightweight.access.token.enabled	true
5ad6ff62-dcfe-479b-b323-cd560f4a7799	oauth2.device.authorization.grant.enabled	false
5ad6ff62-dcfe-479b-b323-cd560f4a7799	oidc.ciba.grant.enabled	false
5ad6ff62-dcfe-479b-b323-cd560f4a7799	post.logout.redirect.uris	*
5ad6ff62-dcfe-479b-b323-cd560f4a7799	backchannel.logout.session.required	true
5ad6ff62-dcfe-479b-b323-cd560f4a7799	backchannel.logout.revoke.offline.tokens	false
5ad6ff62-dcfe-479b-b323-cd560f4a7799	client.secret.creation.time	1729463101
5ad6ff62-dcfe-479b-b323-cd560f4a7799	realm_client	false
5ad6ff62-dcfe-479b-b323-cd560f4a7799	display.on.consent.screen	false
5ad6ff62-dcfe-479b-b323-cd560f4a7799	jwt.credential.certificate	MIICpTCCAY0CBgGSrA5onTANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtmZG8tbWFuYWdlcjAeFw0yNDEwMjAyMjI5MzhaFw0zNDEwMjAyMjMxMThaMBYxFDASBgNVBAMMC2Zkby1tYW5hZ2VyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsYcSy3oQSu4Kb0i6CT5YlZbmhWEFm/7zw0z9Alq0QKVWzWSsfNMdV738mMdPcXbibG7wWJ1kir62Xe7nwsgw4ya329Qf53jCEN8HNuCHIl4m5gI7cDl5rEnL5qq0TMweS/os2GCvw48fEG5pwXl9t0KkBjmhwEoa3w3yCKw8zbMzatdOOmrA+MyX/0k4nUAqGSIglhWdyEWZz2C6YiMKGXg0FJ90wbLRuGCOgzC3hD7iVvofmvnzm6hRnsrSrrw3LWMnRmJDA9f3rUmyuQoIHg2bzKFYwxCGUK8Hz+FfU3qaK6EjBiyxfMdmSA2OLomXVx4yedOhYIyj2VUjnObJVwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBLOfpH0c9qt9x1vaERw2PHw0WkoWD3kqx0qk0UTso4De6p9hXUNeErbzsvHSazEY6yRjwXs/XrzBVQq5aLPo2opkwsUY5Ku5Yno2svSBSRTmFegcVkL3NaT4MhvrFHsuN5TKb7yF01eCMkbxkpkJZA1PKeEK0ZKJFTfsVi/9NABPMOWq/2xzdC2qDOynUV4NQqFM5sgXWU208C+vjmwG3orQN8wA6QFP2WbudrkWPPoWSLK6vxqxy1IyF1ZipYdWTJmYIixl9irljDymyux1JWIm/TFGrmD3zD7lNXB5qIlMF/5am0ZG5J3julwb5xAc9p4GUgb6UJFWgip/z5TXzp
5ad6ff62-dcfe-479b-b323-cd560f4a7799	use.jwks.url	false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
357233d2-4de7-45a5-b6d0-98a7f2127f19	offline_access	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect built-in scope: offline_access	openid-connect
562b910d-58cd-4605-aac7-f7d62e644c7b	role_list	8fb72edd-3595-407b-9597-900a93b73829	SAML role list	saml
d4b92a48-9fd2-4597-80bd-7881fff42353	saml_organization	8fb72edd-3595-407b-9597-900a93b73829	Organization Membership	saml
ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	profile	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect built-in scope: profile	openid-connect
abdaf343-7b51-44c1-8123-f45faf6faf9e	email	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect built-in scope: email	openid-connect
bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	address	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect built-in scope: address	openid-connect
431c73c1-540b-40dc-937a-0d6cd14fe49b	phone	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect built-in scope: phone	openid-connect
eb82c1ec-2fbd-456e-8249-65b528de8f54	roles	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect scope for add user roles to the access token	openid-connect
d92928fc-caad-4643-9a48-cdab53080206	web-origins	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect scope for add allowed web origins to the access token	openid-connect
383fc2af-efff-4e69-b6de-96317ddff877	microprofile-jwt	8fb72edd-3595-407b-9597-900a93b73829	Microprofile - JWT built-in scope	openid-connect
77715671-f192-4f2c-9f92-76c8d24d12e6	acr	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
4c3ceb89-085e-4b44-95b3-f17940951afe	basic	8fb72edd-3595-407b-9597-900a93b73829	OpenID Connect scope for add all basic claims to the token	openid-connect
167ecda7-dfc5-4059-b1aa-a7c424f0c295	organization	8fb72edd-3595-407b-9597-900a93b73829	Additional claims about the organization a subject belongs to	openid-connect
186249ad-586f-4609-af37-92c9de6c587d	offline_access	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect built-in scope: offline_access	openid-connect
6e3e7365-c3c3-4793-9cda-8acdf6905956	role_list	106128c4-abe4-410c-82af-b8d094c1c313	SAML role list	saml
541e36b2-fa22-428d-935d-d69ab382fa45	saml_organization	106128c4-abe4-410c-82af-b8d094c1c313	Organization Membership	saml
d609acfd-2a2d-4cc3-beae-7e57214766b0	profile	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect built-in scope: profile	openid-connect
9a8bde13-3625-43a2-abe3-ff373fdaa243	email	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect built-in scope: email	openid-connect
3d914493-56ec-4fd5-bb7a-6523e38cdda0	address	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect built-in scope: address	openid-connect
fe1dc014-a6b3-4b37-a8da-b259dd1cd057	phone	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect built-in scope: phone	openid-connect
b19b596e-bd20-46c4-aa1f-20e02d39f33b	roles	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect scope for add user roles to the access token	openid-connect
d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	web-origins	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect scope for add allowed web origins to the access token	openid-connect
004c569d-07a9-401b-b218-5cec626a0c28	microprofile-jwt	106128c4-abe4-410c-82af-b8d094c1c313	Microprofile - JWT built-in scope	openid-connect
92e20777-eba7-4271-919d-af54d5b790dc	acr	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
e23685c8-91dd-48ed-8d80-4ee85e2d62ef	basic	106128c4-abe4-410c-82af-b8d094c1c313	OpenID Connect scope for add all basic claims to the token	openid-connect
772a7d75-ddc7-403b-8d0e-f17662bbda42	organization	106128c4-abe4-410c-82af-b8d094c1c313	Additional claims about the organization a subject belongs to	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
357233d2-4de7-45a5-b6d0-98a7f2127f19	true	display.on.consent.screen
357233d2-4de7-45a5-b6d0-98a7f2127f19	${offlineAccessScopeConsentText}	consent.screen.text
562b910d-58cd-4605-aac7-f7d62e644c7b	true	display.on.consent.screen
562b910d-58cd-4605-aac7-f7d62e644c7b	${samlRoleListScopeConsentText}	consent.screen.text
d4b92a48-9fd2-4597-80bd-7881fff42353	false	display.on.consent.screen
ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	true	display.on.consent.screen
ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	${profileScopeConsentText}	consent.screen.text
ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	true	include.in.token.scope
abdaf343-7b51-44c1-8123-f45faf6faf9e	true	display.on.consent.screen
abdaf343-7b51-44c1-8123-f45faf6faf9e	${emailScopeConsentText}	consent.screen.text
abdaf343-7b51-44c1-8123-f45faf6faf9e	true	include.in.token.scope
bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	true	display.on.consent.screen
bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	${addressScopeConsentText}	consent.screen.text
bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	true	include.in.token.scope
431c73c1-540b-40dc-937a-0d6cd14fe49b	true	display.on.consent.screen
431c73c1-540b-40dc-937a-0d6cd14fe49b	${phoneScopeConsentText}	consent.screen.text
431c73c1-540b-40dc-937a-0d6cd14fe49b	true	include.in.token.scope
eb82c1ec-2fbd-456e-8249-65b528de8f54	true	display.on.consent.screen
eb82c1ec-2fbd-456e-8249-65b528de8f54	${rolesScopeConsentText}	consent.screen.text
eb82c1ec-2fbd-456e-8249-65b528de8f54	false	include.in.token.scope
d92928fc-caad-4643-9a48-cdab53080206	false	display.on.consent.screen
d92928fc-caad-4643-9a48-cdab53080206		consent.screen.text
d92928fc-caad-4643-9a48-cdab53080206	false	include.in.token.scope
383fc2af-efff-4e69-b6de-96317ddff877	false	display.on.consent.screen
383fc2af-efff-4e69-b6de-96317ddff877	true	include.in.token.scope
77715671-f192-4f2c-9f92-76c8d24d12e6	false	display.on.consent.screen
77715671-f192-4f2c-9f92-76c8d24d12e6	false	include.in.token.scope
4c3ceb89-085e-4b44-95b3-f17940951afe	false	display.on.consent.screen
4c3ceb89-085e-4b44-95b3-f17940951afe	false	include.in.token.scope
167ecda7-dfc5-4059-b1aa-a7c424f0c295	true	display.on.consent.screen
167ecda7-dfc5-4059-b1aa-a7c424f0c295	${organizationScopeConsentText}	consent.screen.text
167ecda7-dfc5-4059-b1aa-a7c424f0c295	true	include.in.token.scope
186249ad-586f-4609-af37-92c9de6c587d	true	display.on.consent.screen
186249ad-586f-4609-af37-92c9de6c587d	${offlineAccessScopeConsentText}	consent.screen.text
6e3e7365-c3c3-4793-9cda-8acdf6905956	true	display.on.consent.screen
6e3e7365-c3c3-4793-9cda-8acdf6905956	${samlRoleListScopeConsentText}	consent.screen.text
541e36b2-fa22-428d-935d-d69ab382fa45	false	display.on.consent.screen
d609acfd-2a2d-4cc3-beae-7e57214766b0	true	display.on.consent.screen
d609acfd-2a2d-4cc3-beae-7e57214766b0	${profileScopeConsentText}	consent.screen.text
d609acfd-2a2d-4cc3-beae-7e57214766b0	true	include.in.token.scope
9a8bde13-3625-43a2-abe3-ff373fdaa243	true	display.on.consent.screen
9a8bde13-3625-43a2-abe3-ff373fdaa243	${emailScopeConsentText}	consent.screen.text
9a8bde13-3625-43a2-abe3-ff373fdaa243	true	include.in.token.scope
3d914493-56ec-4fd5-bb7a-6523e38cdda0	true	display.on.consent.screen
3d914493-56ec-4fd5-bb7a-6523e38cdda0	${addressScopeConsentText}	consent.screen.text
3d914493-56ec-4fd5-bb7a-6523e38cdda0	true	include.in.token.scope
fe1dc014-a6b3-4b37-a8da-b259dd1cd057	true	display.on.consent.screen
fe1dc014-a6b3-4b37-a8da-b259dd1cd057	${phoneScopeConsentText}	consent.screen.text
fe1dc014-a6b3-4b37-a8da-b259dd1cd057	true	include.in.token.scope
b19b596e-bd20-46c4-aa1f-20e02d39f33b	true	display.on.consent.screen
b19b596e-bd20-46c4-aa1f-20e02d39f33b	${rolesScopeConsentText}	consent.screen.text
b19b596e-bd20-46c4-aa1f-20e02d39f33b	false	include.in.token.scope
d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	false	display.on.consent.screen
d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef		consent.screen.text
d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	false	include.in.token.scope
004c569d-07a9-401b-b218-5cec626a0c28	false	display.on.consent.screen
004c569d-07a9-401b-b218-5cec626a0c28	true	include.in.token.scope
92e20777-eba7-4271-919d-af54d5b790dc	false	display.on.consent.screen
92e20777-eba7-4271-919d-af54d5b790dc	false	include.in.token.scope
e23685c8-91dd-48ed-8d80-4ee85e2d62ef	false	display.on.consent.screen
e23685c8-91dd-48ed-8d80-4ee85e2d62ef	false	include.in.token.scope
772a7d75-ddc7-403b-8d0e-f17662bbda42	true	display.on.consent.screen
772a7d75-ddc7-403b-8d0e-f17662bbda42	${organizationScopeConsentText}	consent.screen.text
772a7d75-ddc7-403b-8d0e-f17662bbda42	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
e58cdd2a-c86d-4477-9182-8d2448818975	d92928fc-caad-4643-9a48-cdab53080206	t
e58cdd2a-c86d-4477-9182-8d2448818975	abdaf343-7b51-44c1-8123-f45faf6faf9e	t
e58cdd2a-c86d-4477-9182-8d2448818975	77715671-f192-4f2c-9f92-76c8d24d12e6	t
e58cdd2a-c86d-4477-9182-8d2448818975	eb82c1ec-2fbd-456e-8249-65b528de8f54	t
e58cdd2a-c86d-4477-9182-8d2448818975	4c3ceb89-085e-4b44-95b3-f17940951afe	t
e58cdd2a-c86d-4477-9182-8d2448818975	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	t
e58cdd2a-c86d-4477-9182-8d2448818975	431c73c1-540b-40dc-937a-0d6cd14fe49b	f
e58cdd2a-c86d-4477-9182-8d2448818975	357233d2-4de7-45a5-b6d0-98a7f2127f19	f
e58cdd2a-c86d-4477-9182-8d2448818975	383fc2af-efff-4e69-b6de-96317ddff877	f
e58cdd2a-c86d-4477-9182-8d2448818975	167ecda7-dfc5-4059-b1aa-a7c424f0c295	f
e58cdd2a-c86d-4477-9182-8d2448818975	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	f
a1009637-d602-4178-8531-be4cd5eddbdd	d92928fc-caad-4643-9a48-cdab53080206	t
a1009637-d602-4178-8531-be4cd5eddbdd	abdaf343-7b51-44c1-8123-f45faf6faf9e	t
a1009637-d602-4178-8531-be4cd5eddbdd	77715671-f192-4f2c-9f92-76c8d24d12e6	t
a1009637-d602-4178-8531-be4cd5eddbdd	eb82c1ec-2fbd-456e-8249-65b528de8f54	t
a1009637-d602-4178-8531-be4cd5eddbdd	4c3ceb89-085e-4b44-95b3-f17940951afe	t
a1009637-d602-4178-8531-be4cd5eddbdd	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	t
a1009637-d602-4178-8531-be4cd5eddbdd	431c73c1-540b-40dc-937a-0d6cd14fe49b	f
a1009637-d602-4178-8531-be4cd5eddbdd	357233d2-4de7-45a5-b6d0-98a7f2127f19	f
a1009637-d602-4178-8531-be4cd5eddbdd	383fc2af-efff-4e69-b6de-96317ddff877	f
a1009637-d602-4178-8531-be4cd5eddbdd	167ecda7-dfc5-4059-b1aa-a7c424f0c295	f
a1009637-d602-4178-8531-be4cd5eddbdd	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	f
2949de44-3c2a-4943-a0be-817417e271a2	d92928fc-caad-4643-9a48-cdab53080206	t
2949de44-3c2a-4943-a0be-817417e271a2	abdaf343-7b51-44c1-8123-f45faf6faf9e	t
2949de44-3c2a-4943-a0be-817417e271a2	77715671-f192-4f2c-9f92-76c8d24d12e6	t
2949de44-3c2a-4943-a0be-817417e271a2	eb82c1ec-2fbd-456e-8249-65b528de8f54	t
2949de44-3c2a-4943-a0be-817417e271a2	4c3ceb89-085e-4b44-95b3-f17940951afe	t
2949de44-3c2a-4943-a0be-817417e271a2	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	t
2949de44-3c2a-4943-a0be-817417e271a2	431c73c1-540b-40dc-937a-0d6cd14fe49b	f
2949de44-3c2a-4943-a0be-817417e271a2	357233d2-4de7-45a5-b6d0-98a7f2127f19	f
2949de44-3c2a-4943-a0be-817417e271a2	383fc2af-efff-4e69-b6de-96317ddff877	f
2949de44-3c2a-4943-a0be-817417e271a2	167ecda7-dfc5-4059-b1aa-a7c424f0c295	f
2949de44-3c2a-4943-a0be-817417e271a2	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	f
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	d92928fc-caad-4643-9a48-cdab53080206	t
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	abdaf343-7b51-44c1-8123-f45faf6faf9e	t
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	77715671-f192-4f2c-9f92-76c8d24d12e6	t
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	eb82c1ec-2fbd-456e-8249-65b528de8f54	t
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	4c3ceb89-085e-4b44-95b3-f17940951afe	t
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	t
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	431c73c1-540b-40dc-937a-0d6cd14fe49b	f
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	357233d2-4de7-45a5-b6d0-98a7f2127f19	f
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	383fc2af-efff-4e69-b6de-96317ddff877	f
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	167ecda7-dfc5-4059-b1aa-a7c424f0c295	f
a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	f
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	d92928fc-caad-4643-9a48-cdab53080206	t
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	abdaf343-7b51-44c1-8123-f45faf6faf9e	t
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	77715671-f192-4f2c-9f92-76c8d24d12e6	t
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	eb82c1ec-2fbd-456e-8249-65b528de8f54	t
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	4c3ceb89-085e-4b44-95b3-f17940951afe	t
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	t
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	431c73c1-540b-40dc-937a-0d6cd14fe49b	f
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	357233d2-4de7-45a5-b6d0-98a7f2127f19	f
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	383fc2af-efff-4e69-b6de-96317ddff877	f
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	167ecda7-dfc5-4059-b1aa-a7c424f0c295	f
ffb4d769-de1f-4d8a-a202-8ae8c60485e0	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	f
83e64015-a218-4024-8318-fb3ffe674c30	d92928fc-caad-4643-9a48-cdab53080206	t
83e64015-a218-4024-8318-fb3ffe674c30	abdaf343-7b51-44c1-8123-f45faf6faf9e	t
83e64015-a218-4024-8318-fb3ffe674c30	77715671-f192-4f2c-9f92-76c8d24d12e6	t
83e64015-a218-4024-8318-fb3ffe674c30	eb82c1ec-2fbd-456e-8249-65b528de8f54	t
83e64015-a218-4024-8318-fb3ffe674c30	4c3ceb89-085e-4b44-95b3-f17940951afe	t
83e64015-a218-4024-8318-fb3ffe674c30	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	t
83e64015-a218-4024-8318-fb3ffe674c30	431c73c1-540b-40dc-937a-0d6cd14fe49b	f
83e64015-a218-4024-8318-fb3ffe674c30	357233d2-4de7-45a5-b6d0-98a7f2127f19	f
83e64015-a218-4024-8318-fb3ffe674c30	383fc2af-efff-4e69-b6de-96317ddff877	f
83e64015-a218-4024-8318-fb3ffe674c30	167ecda7-dfc5-4059-b1aa-a7c424f0c295	f
83e64015-a218-4024-8318-fb3ffe674c30	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	f
22a1d428-ec7b-4f91-a222-06c55a128831	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
22a1d428-ec7b-4f91-a222-06c55a128831	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
22a1d428-ec7b-4f91-a222-06c55a128831	92e20777-eba7-4271-919d-af54d5b790dc	t
22a1d428-ec7b-4f91-a222-06c55a128831	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
22a1d428-ec7b-4f91-a222-06c55a128831	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
22a1d428-ec7b-4f91-a222-06c55a128831	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
22a1d428-ec7b-4f91-a222-06c55a128831	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
22a1d428-ec7b-4f91-a222-06c55a128831	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
22a1d428-ec7b-4f91-a222-06c55a128831	004c569d-07a9-401b-b218-5cec626a0c28	f
22a1d428-ec7b-4f91-a222-06c55a128831	186249ad-586f-4609-af37-92c9de6c587d	f
22a1d428-ec7b-4f91-a222-06c55a128831	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
1ef61626-bfd6-4c61-ba3c-e93a688b330f	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
1ef61626-bfd6-4c61-ba3c-e93a688b330f	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
1ef61626-bfd6-4c61-ba3c-e93a688b330f	92e20777-eba7-4271-919d-af54d5b790dc	t
1ef61626-bfd6-4c61-ba3c-e93a688b330f	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
1ef61626-bfd6-4c61-ba3c-e93a688b330f	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
1ef61626-bfd6-4c61-ba3c-e93a688b330f	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
1ef61626-bfd6-4c61-ba3c-e93a688b330f	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
1ef61626-bfd6-4c61-ba3c-e93a688b330f	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
1ef61626-bfd6-4c61-ba3c-e93a688b330f	004c569d-07a9-401b-b218-5cec626a0c28	f
1ef61626-bfd6-4c61-ba3c-e93a688b330f	186249ad-586f-4609-af37-92c9de6c587d	f
1ef61626-bfd6-4c61-ba3c-e93a688b330f	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
e38c9b0b-4236-42e1-a8bc-fcc54315a449	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
e38c9b0b-4236-42e1-a8bc-fcc54315a449	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
e38c9b0b-4236-42e1-a8bc-fcc54315a449	92e20777-eba7-4271-919d-af54d5b790dc	t
e38c9b0b-4236-42e1-a8bc-fcc54315a449	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
e38c9b0b-4236-42e1-a8bc-fcc54315a449	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
e38c9b0b-4236-42e1-a8bc-fcc54315a449	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
e38c9b0b-4236-42e1-a8bc-fcc54315a449	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
e38c9b0b-4236-42e1-a8bc-fcc54315a449	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
e38c9b0b-4236-42e1-a8bc-fcc54315a449	004c569d-07a9-401b-b218-5cec626a0c28	f
e38c9b0b-4236-42e1-a8bc-fcc54315a449	186249ad-586f-4609-af37-92c9de6c587d	f
e38c9b0b-4236-42e1-a8bc-fcc54315a449	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
7eed5789-b554-45ae-b162-5f68d136ff21	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
7eed5789-b554-45ae-b162-5f68d136ff21	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
7eed5789-b554-45ae-b162-5f68d136ff21	92e20777-eba7-4271-919d-af54d5b790dc	t
7eed5789-b554-45ae-b162-5f68d136ff21	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
7eed5789-b554-45ae-b162-5f68d136ff21	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
7eed5789-b554-45ae-b162-5f68d136ff21	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
7eed5789-b554-45ae-b162-5f68d136ff21	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
7eed5789-b554-45ae-b162-5f68d136ff21	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
7eed5789-b554-45ae-b162-5f68d136ff21	004c569d-07a9-401b-b218-5cec626a0c28	f
7eed5789-b554-45ae-b162-5f68d136ff21	186249ad-586f-4609-af37-92c9de6c587d	f
7eed5789-b554-45ae-b162-5f68d136ff21	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
6c5705d3-5e1e-4931-b897-d954d6da7b05	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
6c5705d3-5e1e-4931-b897-d954d6da7b05	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
6c5705d3-5e1e-4931-b897-d954d6da7b05	92e20777-eba7-4271-919d-af54d5b790dc	t
6c5705d3-5e1e-4931-b897-d954d6da7b05	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
6c5705d3-5e1e-4931-b897-d954d6da7b05	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
6c5705d3-5e1e-4931-b897-d954d6da7b05	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
6c5705d3-5e1e-4931-b897-d954d6da7b05	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
6c5705d3-5e1e-4931-b897-d954d6da7b05	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
6c5705d3-5e1e-4931-b897-d954d6da7b05	004c569d-07a9-401b-b218-5cec626a0c28	f
6c5705d3-5e1e-4931-b897-d954d6da7b05	186249ad-586f-4609-af37-92c9de6c587d	f
6c5705d3-5e1e-4931-b897-d954d6da7b05	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
0e9e2341-b009-4953-808d-0492c93c809d	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
0e9e2341-b009-4953-808d-0492c93c809d	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
0e9e2341-b009-4953-808d-0492c93c809d	92e20777-eba7-4271-919d-af54d5b790dc	t
0e9e2341-b009-4953-808d-0492c93c809d	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
0e9e2341-b009-4953-808d-0492c93c809d	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
0e9e2341-b009-4953-808d-0492c93c809d	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
0e9e2341-b009-4953-808d-0492c93c809d	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
0e9e2341-b009-4953-808d-0492c93c809d	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
0e9e2341-b009-4953-808d-0492c93c809d	004c569d-07a9-401b-b218-5cec626a0c28	f
0e9e2341-b009-4953-808d-0492c93c809d	186249ad-586f-4609-af37-92c9de6c587d	f
0e9e2341-b009-4953-808d-0492c93c809d	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
5ad6ff62-dcfe-479b-b323-cd560f4a7799	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
5ad6ff62-dcfe-479b-b323-cd560f4a7799	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
5ad6ff62-dcfe-479b-b323-cd560f4a7799	92e20777-eba7-4271-919d-af54d5b790dc	t
5ad6ff62-dcfe-479b-b323-cd560f4a7799	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
5ad6ff62-dcfe-479b-b323-cd560f4a7799	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
5ad6ff62-dcfe-479b-b323-cd560f4a7799	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
5ad6ff62-dcfe-479b-b323-cd560f4a7799	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
5ad6ff62-dcfe-479b-b323-cd560f4a7799	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
5ad6ff62-dcfe-479b-b323-cd560f4a7799	004c569d-07a9-401b-b218-5cec626a0c28	f
5ad6ff62-dcfe-479b-b323-cd560f4a7799	186249ad-586f-4609-af37-92c9de6c587d	f
5ad6ff62-dcfe-479b-b323-cd560f4a7799	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
357233d2-4de7-45a5-b6d0-98a7f2127f19	ba676c22-696b-4d11-832b-7b9a507f75cd
186249ad-586f-4609-af37-92c9de6c587d	c09e84c1-5a5d-43a8-86b6-010770c15dcf
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
81bc7e70-09a8-4dbf-9070-3049fc3e2952	Trusted Hosts	8fb72edd-3595-407b-9597-900a93b73829	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	anonymous
71e8862f-22fa-4564-9f1a-f3a254e231cf	Consent Required	8fb72edd-3595-407b-9597-900a93b73829	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	anonymous
8ab1cf5a-d868-4e4a-9c56-f4767d384aeb	Full Scope Disabled	8fb72edd-3595-407b-9597-900a93b73829	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	anonymous
466b237c-83f4-4091-8db6-c3edec398dae	Max Clients Limit	8fb72edd-3595-407b-9597-900a93b73829	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	anonymous
e4ba51d9-3640-4dc7-8d93-1caae698a66f	Allowed Protocol Mapper Types	8fb72edd-3595-407b-9597-900a93b73829	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	anonymous
969f59c1-119d-4732-96c8-d70b57ac085e	Allowed Client Scopes	8fb72edd-3595-407b-9597-900a93b73829	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	anonymous
57805618-a9a4-4107-a054-def3531fb953	Allowed Protocol Mapper Types	8fb72edd-3595-407b-9597-900a93b73829	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	authenticated
acdfbf1d-e903-4ced-9323-59a4c1098c8e	Allowed Client Scopes	8fb72edd-3595-407b-9597-900a93b73829	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	8fb72edd-3595-407b-9597-900a93b73829	authenticated
dc37b8d6-6a57-41eb-90f1-b926e925a31b	rsa-generated	8fb72edd-3595-407b-9597-900a93b73829	rsa-generated	org.keycloak.keys.KeyProvider	8fb72edd-3595-407b-9597-900a93b73829	\N
10ab87d8-1291-49e2-98d1-6d21ff313ca7	rsa-enc-generated	8fb72edd-3595-407b-9597-900a93b73829	rsa-enc-generated	org.keycloak.keys.KeyProvider	8fb72edd-3595-407b-9597-900a93b73829	\N
7e3bd5d8-e5b1-43dd-aee2-5f0e3f7b5d56	hmac-generated-hs512	8fb72edd-3595-407b-9597-900a93b73829	hmac-generated	org.keycloak.keys.KeyProvider	8fb72edd-3595-407b-9597-900a93b73829	\N
03f03bc0-6223-4679-b5b4-bfc0327709c6	aes-generated	8fb72edd-3595-407b-9597-900a93b73829	aes-generated	org.keycloak.keys.KeyProvider	8fb72edd-3595-407b-9597-900a93b73829	\N
1ce68af4-9587-46a2-bc37-049397fbe8bb	\N	8fb72edd-3595-407b-9597-900a93b73829	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	8fb72edd-3595-407b-9597-900a93b73829	\N
0d12f447-5d23-4d5d-8613-94a444112957	rsa-generated	106128c4-abe4-410c-82af-b8d094c1c313	rsa-generated	org.keycloak.keys.KeyProvider	106128c4-abe4-410c-82af-b8d094c1c313	\N
c2cdc4ce-95e9-41d2-ac82-4fb157b4f3a7	rsa-enc-generated	106128c4-abe4-410c-82af-b8d094c1c313	rsa-enc-generated	org.keycloak.keys.KeyProvider	106128c4-abe4-410c-82af-b8d094c1c313	\N
67a54da7-6ccb-4b11-b0e3-b4ef264c223c	hmac-generated-hs512	106128c4-abe4-410c-82af-b8d094c1c313	hmac-generated	org.keycloak.keys.KeyProvider	106128c4-abe4-410c-82af-b8d094c1c313	\N
2874d0a6-fe82-45ac-b1d8-18e0f9f54812	aes-generated	106128c4-abe4-410c-82af-b8d094c1c313	aes-generated	org.keycloak.keys.KeyProvider	106128c4-abe4-410c-82af-b8d094c1c313	\N
51053694-38cc-4b4b-98dc-db072ae1596f	Trusted Hosts	106128c4-abe4-410c-82af-b8d094c1c313	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	anonymous
ef7921e9-e759-49bf-87a1-bc85f19f3bfe	Consent Required	106128c4-abe4-410c-82af-b8d094c1c313	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	anonymous
d2b89e6c-d141-403a-99ac-c7402ef1ef1b	Full Scope Disabled	106128c4-abe4-410c-82af-b8d094c1c313	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	anonymous
a77819a2-7727-4e8d-bd67-7310d638950a	Max Clients Limit	106128c4-abe4-410c-82af-b8d094c1c313	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	anonymous
f32a0288-45fa-4568-8d11-c4a105adcbd0	Allowed Protocol Mapper Types	106128c4-abe4-410c-82af-b8d094c1c313	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	anonymous
31d92787-49c4-4794-b404-e5e93be5db8a	Allowed Client Scopes	106128c4-abe4-410c-82af-b8d094c1c313	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	anonymous
a73ac6cb-54a9-4e55-a17d-e0b011867619	Allowed Protocol Mapper Types	106128c4-abe4-410c-82af-b8d094c1c313	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	authenticated
00db9820-21e1-4fa7-a2a8-5010cb6330fb	Allowed Client Scopes	106128c4-abe4-410c-82af-b8d094c1c313	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	106128c4-abe4-410c-82af-b8d094c1c313	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
5b0df5be-2f6a-4c45-b416-ce5ebb35fa12	acdfbf1d-e903-4ced-9323-59a4c1098c8e	allow-default-scopes	true
7179196c-ae19-4a32-b45e-8f11330b489c	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	oidc-address-mapper
38ef037b-6246-499b-b507-01adae723772	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	saml-role-list-mapper
8840ccb7-5044-4946-aff1-bb80476ec7ec	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	saml-user-attribute-mapper
484b76aa-1e51-4bb3-b9fb-59af572ecfa6	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
a91f14b0-210f-4684-a23b-f1dd460c9ec4	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	saml-user-property-mapper
6ece0cf7-e948-42e3-91ad-23e1e39e9b84	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
bbf94606-ee13-4d40-af99-aaa96fd262df	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	oidc-full-name-mapper
995c8504-837a-4d44-9b31-3e3b78bcd089	57805618-a9a4-4107-a054-def3531fb953	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
819606d2-d886-496c-95e8-2a8d918bf1b9	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	oidc-address-mapper
ab36626a-5b8a-47bf-b0c0-055639433eab	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
66650dc0-62a1-4169-9efe-6917cdf2be11	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	saml-role-list-mapper
4ff64a2c-a112-4c96-88e2-af814517b603	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
5664b079-2479-4836-80de-153f7998d218	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	saml-user-attribute-mapper
08751a95-904a-4cd2-9e35-187d49c2f43c	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	oidc-full-name-mapper
c2fdf466-c156-432f-aa43-c4148d6a6fbe	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
111600db-71d6-4cf5-ace4-2461427e9a96	e4ba51d9-3640-4dc7-8d93-1caae698a66f	allowed-protocol-mapper-types	saml-user-property-mapper
3ef1830f-27d3-4181-97d9-e8e0550f7536	81bc7e70-09a8-4dbf-9070-3049fc3e2952	host-sending-registration-request-must-match	true
b819eccb-a833-4205-9b2c-e6981a975ed3	81bc7e70-09a8-4dbf-9070-3049fc3e2952	client-uris-must-match	true
4da5b067-b08b-44f0-b077-97e8bcf66765	969f59c1-119d-4732-96c8-d70b57ac085e	allow-default-scopes	true
3c55b94c-9dc2-4a99-aaf4-b0ddb7902110	466b237c-83f4-4091-8db6-c3edec398dae	max-clients	200
e9ae57eb-5ef7-43f4-ac2d-ecf5508493ae	03f03bc0-6223-4679-b5b4-bfc0327709c6	priority	100
ce108dc9-4374-4d6d-baf1-c6a5a59c2d3d	03f03bc0-6223-4679-b5b4-bfc0327709c6	secret	GU7J_JP0m4fhHq6eQ66CtA
22c5d0f0-0679-4225-930f-01a91de09be0	03f03bc0-6223-4679-b5b4-bfc0327709c6	kid	d7fa6a40-12a5-413b-8f49-1031eccf165a
2ad5ab7d-3e8d-424d-8a1f-692d69dfd37c	10ab87d8-1291-49e2-98d1-6d21ff313ca7	certificate	MIICmzCCAYMCBgGSq/zQejANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQxMDIwMjIxMDI1WhcNMzQxMDIwMjIxMjA1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCpoByL3k4lyLYEYeFRGQSKX0RSXl+dNWfZh8/KUGZRCyRImDsoRyu+jM0fjBuw2fdwULh6paIukBun+UtZlzAaF0bNC9flc/c1JzfvyQOpWnPJkKkk6rQTiMy9Dv8PwRqHALqRVyNXVB6vtVaFtQUdrfGcZz0NrchPHRApM7BKojGVO5nqL1n2deqca6R4BjYuAWiS81nFtze+PI80ljfxExflJ7GXMPq/mpnL1V7Y8DOjSMSPVxhP67bUWUw33N2KmVGBuA4NLBvd0zHV3VGg96zhFWyvopsRxtVv31hH5iifZZdaWAkW5svyf3XXC6HPyxqgix0gVpz7w2IRonH/AgMBAAEwDQYJKoZIhvcNAQELBQADggEBABp9OzGkORF2B7GfN83uwTJjHw5Q543jsgR7h0QUHuEN+FfLkJPwx3s5+HyivZlbjp0vqKX3a+gfvkQLqP+OnchnXSTn6VPSmXNxpim59aFwUcKYXd54243kM5cPWtZoW0Rg0wHH8HxqMwD9NymnSqxt9jlhYGv7sjvlcP9WkzpVzJ3Gu7bLvoBQnGydHCfkcQ0WST6uL9cdIj8aOBiSdDlWj3W8aOJMpWrxMeaLKUFX89mMzS0RiOWe3SbUJQZg3b1I1dCnqmqPCspwSBIDo8JA0fZqx8QWGlUT9d2RM94S/PKfU5iJTto3joJD/ngUTasgjf+5AC4LkHwALmbZFDA=
aaf65c62-7180-40cf-bcd6-bb92eec20cfa	10ab87d8-1291-49e2-98d1-6d21ff313ca7	privateKey	MIIEowIBAAKCAQEAqaAci95OJci2BGHhURkEil9EUl5fnTVn2YfPylBmUQskSJg7KEcrvozNH4wbsNn3cFC4eqWiLpAbp/lLWZcwGhdGzQvX5XP3NSc378kDqVpzyZCpJOq0E4jMvQ7/D8EahwC6kVcjV1Qer7VWhbUFHa3xnGc9Da3ITx0QKTOwSqIxlTuZ6i9Z9nXqnGukeAY2LgFokvNZxbc3vjyPNJY38RMX5SexlzD6v5qZy9Ve2PAzo0jEj1cYT+u21FlMN9zdiplRgbgODSwb3dMx1d1RoPes4RVsr6KbEcbVb99YR+Yon2WXWlgJFubL8n911wuhz8saoIsdIFac+8NiEaJx/wIDAQABAoIBADZqm43RaO+dJqtcPTzXkknTyybDiNf1uJWkCKimR1Srht3VHHFM978fC3UZ7Q48trEs7CnIdjGK4JxwENiydGeCXR/Ns1q0a7N9G+hMa+TKFEgvJNwngVKc+dWS+Id00w5JURDsS/WpklibC6FEU9pUIaUjx4XaYN7ke3lEUEN4pDHsqV6eHimnjAn0z6K5H9F8yA7PE/8bfNgXEZpbvdHf+VVECNa2MUXgtAAAHeo0yg8Be0z2+1ZkFtntZvrkDpee4l9Vy7mWs03Cprs6h5Lwr67Qa8L3WcN+pstQkS9IulqgbmDT2ymxYy8ZQnMVfirE0R9p1nu/vRfVfB1KeM0CgYEA2MGzPwUDfJSfXOrmz1LM4Ti2UjOowgDyBlx/WFas9Gwo29Tqad4Dy2bz7JBYIohJd3CELL1tpG9zC8OexJy3GehhRqojWvs5IkZ+uYMTrU37p2Rms7xKTN+X0sDusA8ZTPTstEp03UZfSGFmIgBSHv1WlXFNKngmuhD4iEvDhgsCgYEAyFX146MtFceDdETzc/EbObycjuqMuwqBBL+sjHqlYoyLwaPqMCKJkpUAyFciTeM273y9AOVPthx4iAWXINpfUlZfitFxJOCFPNXGyXrNQrnC3VFI9uYSSgJf4exrdG6SWwHSQTAEiMSCwSeP0f4wSyezkHBObgH0M0LqzUVIQF0CgYBqfqiZctYmtEKj/UlPXUgJ87ooIvdr8dj3ZSSv+03YfPeKIk7Vmt3UZo27kaOru7gUtbRK4vrmildE1WTBBpozYWfBtz/NqJaGj4odjRfy0tisgnivH/iFUmmeg2oCGDj/BWrynY5TVQrlXe03EV9HmIKcw+D817F3Q3VISakTxwKBgHEIVzk+CyUbsea7NKV5J0RXT/ovCoJJ9euo/gEw/flxlTUHeA36nqaO3acrypYpmghb2AQWXfhBbhxJEzEdJOU/CJ85dt44s9RURdnOKNv6FaFryIBN5YnOdyzwiNxjur4QdAIFxrkoLyIuYS45fiQZXW4kf4wAHDmECxkQeyidAoGBAJD6PW5AIFv0y2IkGVT/uz90ryPs0M5f7HE8QzifzH0qWIUW+e4M9JL5WaHU5UaUc/mv3ooCx3sAyKrrHOcL3aUXCEXayX82JO1VzqbTmnbwKCD+Oa4yXo7WrY/NpKwfkg0ILScXzVdDcNSlgBt9zl3IfOVuFKxQ8I228zuwuXpB
e6654a1b-1083-4770-b961-477a64bffeaa	10ab87d8-1291-49e2-98d1-6d21ff313ca7	keyUse	ENC
cf336492-892a-42bd-becf-80b2efd5f391	10ab87d8-1291-49e2-98d1-6d21ff313ca7	algorithm	RSA-OAEP
ce994456-0915-49c3-bcc0-f72ce2c4a60d	10ab87d8-1291-49e2-98d1-6d21ff313ca7	priority	100
b186ee61-ea1b-4b8c-af41-028d220a0052	7e3bd5d8-e5b1-43dd-aee2-5f0e3f7b5d56	secret	iQxmDrqsTmLO-LpXbdTo_nSLkA62J4tP-kS7rzBIO7otLJbsq0qb5S-0F-hf-Sm8YH4SGH7GnqpAVImoZ9hV-WocDsMoH-AwxDBfudtgK5pMGfPRCVj5m8Jbw3KdBnD7-T8EVo7bTkRFmHLfPH5vWV-i6-fd_Z4gY8ZokLJN30k
264779ed-fc49-4aec-bae8-f4f88ac69d75	7e3bd5d8-e5b1-43dd-aee2-5f0e3f7b5d56	kid	c37397f4-6717-49ef-b8d1-32253eeadc8c
7cd912d6-7cdf-4556-9eef-7d6ebee03ce7	7e3bd5d8-e5b1-43dd-aee2-5f0e3f7b5d56	priority	100
505272e2-de69-4761-93f6-2c5a5eb91279	7e3bd5d8-e5b1-43dd-aee2-5f0e3f7b5d56	algorithm	HS512
f48472ea-a7be-4fbb-a25e-66d5b4643514	1ce68af4-9587-46a2-bc37-049397fbe8bb	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
39f3f536-8af3-4584-ab59-01deff4a09e4	dc37b8d6-6a57-41eb-90f1-b926e925a31b	certificate	MIICmzCCAYMCBgGSq/zP0DANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQxMDIwMjIxMDI1WhcNMzQxMDIwMjIxMjA1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZLU8RWeJXs6shseRxlpsfvpSdfrlHRbs3DLn7UjY/phKR4MXAgkpooMti58z9SC9a6kkv0an27UeM355l0gWkMqQq+I4sw5WVFiZYYBdyosWifS+IPBPe4G7r9rGQvT59s3fL/G1SpRR9Q5pFq1WD10vT6VwOwRKIUy/PuxCsKvB0Xc83hBwnhkLjX/9bgtSZtX8q+3gvvTR+bEavuJq7JeuhP6q3TUpG/ogIH0qxykfO3G0fcJE2mcOKXSfe7b8Q8sxaGKSCLa+4Q7ZyeMGDY1JJOYVUqBt/dCgCnm8pOBH1pTgFE0TP8LG7p4ex/8Xgep5Nd8jVxqES+atYnDH7AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAE0HA0bNN6nipMwpICdK+tVj5knckNZBpGbPyFo0PFvN62OwJQzqBpYsk7JnojZpZ6w9vC+bjFVrrjkuBUBrkALYVFAkK7Hpdikfr8JrC5m5w8VwLvm98jDN29n+PBGZRsZD/CDSlnxGfnAS96DWefTVSyNbK7DxznFHWbpcN5aIP1HPW5nRq/KRK741Fnxwswgm0QyfM/n5XLYMrnK6irCP0nQ8kehTO5pcD1sUk3gTM6/3pJ4PHuvc0Gl9XezxhQyMBpte2trkjBPlo3J2SLGT1BvQJBrv+z32/hlvTJp+pTb5i+Z0S2MAIiDHsEswhLetTsbTj8Ey2+tWOgpT2d0=
7dbf9aee-12a6-4470-aa9b-bcde8a7d2ea3	dc37b8d6-6a57-41eb-90f1-b926e925a31b	keyUse	SIG
3e005b75-7cd0-4600-8bac-a31dd0629106	dc37b8d6-6a57-41eb-90f1-b926e925a31b	priority	100
3f4cf639-44e9-4100-880b-18f7f0b75f5f	dc37b8d6-6a57-41eb-90f1-b926e925a31b	privateKey	MIIEpAIBAAKCAQEAmS1PEVniV7OrIbHkcZabH76UnX65R0W7Nwy5+1I2P6YSkeDFwIJKaKDLYufM/UgvWupJL9Gp9u1HjN+eZdIFpDKkKviOLMOVlRYmWGAXcqLFon0viDwT3uBu6/axkL0+fbN3y/xtUqUUfUOaRatVg9dL0+lcDsESiFMvz7sQrCrwdF3PN4QcJ4ZC41//W4LUmbV/Kvt4L700fmxGr7iauyXroT+qt01KRv6ICB9KscpHztxtH3CRNpnDil0n3u2/EPLMWhikgi2vuEO2cnjBg2NSSTmFVKgbf3QoAp5vKTgR9aU4BRNEz/Cxu6eHsf/F4HqeTXfI1cahEvmrWJwx+wIDAQABAoIBABMvwrSorppPrgLldnjn5XxfcdwccHbF/EJT/MPHM3Zbhf3xyrNnXoymf3NfF6UuMohPymUL/R8p74lsxTl5yi0cDsY3Jg/jW8w13w2405cPXnQQ/DAzXkXPlPVHjExV+ArkvP+3GbZ9aQibvCo34NlH0X60v0w10O10hgueIeN+t83wfR77v5KBCYASEsRzqvnJVIHjEK4yIWaJNJopTxc4yulER97X6XKis2IjNx7VaPY8UtNuolIFaQpXG+5DswzYt82cTb9t/3OjMzUyfI87qINjBJ28vNQlW5PTW/snGDAROfmsbEgMUaDqlapuI3RZjY2yHOnmwnGiRDcydOkCgYEAxpbpDEZId3kGrCA0hvFsoDb5/Yfsg+26RWsyKaDmiZSEXhbVzFt5vekDesIg0zhy8AQmYIWdPLoAMKlbhWbf30oJcHdNRkdNcBLtlotF/oHLgtBI09qikYMJ6pGPjgtppubQbBhINnJMNZZaaHxCQOGHoow61KDj82aedTfkMd0CgYEAxXWJn2BZqEqPzhznNfkus/NUPiUtP5/ik36MQFEnibpUBaoffMashsSTXDVahIIGfGIbVkygqWJBuQ64J1Z6q3ZWBPZYIJXCAKm2leVWMiDNfPxmmtAFBbubLaf6NaTOGIFkny1dkOSIBdpDR8gRWWI2MNMOKDEnRngJUtXCcbcCgYEAwCmXKMF5reH2iug+67UBn6aTELlOK/sFm9a2m4GOkuKbk1AVYcHCc/nd3BOtH7YnwgjB+fRQykpRlMTMQrHhP3es2p8Wr0KftCscq+fouvVtsA9L6XROiu950Pk5KAHzIgWG+JImjkjbZZ8vrJtQoOebD7cR1l45NXW/Lz3+GiECgYEAozYF7SBcu0f2GW22htxSiBdGuJ9OCVsEktl03+y0e5jxvkTiBebJ0BNHol3PVduLtN/6rJhl69v1axsJiCpo9rS3YR6ltTlTw+yDqN6JIqIOd5LA1JHAtP5ew5wmqpRwbbz2CMQcpJjg/cVs+zYZcQJGvJCXEQ2f4xVwz3E0aX0CgYAHm9rfFftg1oT6hSJZ4ZEo82JUwvbReY+qISK7VOtiUH0BDmV/+4STdwECFmQH3yWZM6FllAgLxld2peM5HZ6lI128ass6AVpHgUyM/q2V+j+V6UE6V+c1SVT1GDrhgp14NUJDMx6BHTu/qEoonMqKQKlJLA7wf0KkTG3OI3JSYA==
15e8ef3d-b884-4612-8946-d51c46af2103	2874d0a6-fe82-45ac-b1d8-18e0f9f54812	kid	f928d545-fe66-4853-9468-3c5ec152ba83
36caed29-fb24-4fa9-a06f-3dfe7adccc7c	2874d0a6-fe82-45ac-b1d8-18e0f9f54812	secret	-NX28viDRNevC7uShmUeQA
c80f4630-00df-407b-923c-830e1cfeb4eb	2874d0a6-fe82-45ac-b1d8-18e0f9f54812	priority	100
2d3f1f66-25f9-4624-bb7b-ce56a11d6dce	0d12f447-5d23-4d5d-8613-94a444112957	keyUse	SIG
14261e5d-4508-4f38-95fc-10c3c2ebacea	0d12f447-5d23-4d5d-8613-94a444112957	certificate	MIICozCCAYsCBgGSq/6IdzANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDDApGZG9UZXN0YmVkMB4XDTI0MTAyMDIyMTIxOFoXDTM0MTAyMDIyMTM1OFowFTETMBEGA1UEAwwKRmRvVGVzdGJlZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKw3lFybfg4PZx0TvOcNN6Rvj/e70CTI3YtHMtQn52mBFPgyiphu8cghmdTK8mSwFpvj+lLYWDhB+mDzta1YcqCAW4ykeNADla5D+MDS2WBgpZAsTSlUkeXKboFk30H2B1YsvO1sHj23raEekXwZAwWQrZ9eKSBtnsaPShyWj9vtxHUnU46+r7NuD7SVJOWZciB4KUMiKD967IvEw9tPHJUX8yXwwLzMHCkf9eQ+PkfbuFopetmBTPfEaD0I90Z5EcGyLHmbaOjLzhlF6HWXFeW52QMw14usDfsk5iuW5qmIPMxImfYuSs1S9bFbV28aSWVD4I2wuGZTUYeX5fhutYMCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAI6oOSsWQYxU6tLMVwHaM99PxBty3udhnHefiEcyJpffw4YLnIMy9nZhoLMgE/51QNOhq18kFO/COvvlig/fJXIDyrX6h0s4wKzKixbLpOh4Bm2z5faPirGE1qbgZJkoMNn2WJGSPG3kxQkQJkshFCyty3doV6268b1XNpFN+G/ia8dLL65PYrGob5JoqnOtodaJ/gl6jgnv7peDiQ/YJyt2MvhNUndlx2Vo0T/aEno967XDL8gi5qVF8IDCvg3ToxKMgK8RtHr1I+xkBOdWpPTkZ743fvWjcPec4F2j38dFQ7e7EzscxBuRoYko+lS7i9uWTAvzpSRmd83EFsdF+HQ==
98eda633-e95e-4a1f-be9b-581e5ed97621	0d12f447-5d23-4d5d-8613-94a444112957	priority	100
84e15fdc-40e0-4215-a2f5-db703721663e	0d12f447-5d23-4d5d-8613-94a444112957	privateKey	MIIEpAIBAAKCAQEArDeUXJt+Dg9nHRO85w03pG+P97vQJMjdi0cy1CfnaYEU+DKKmG7xyCGZ1MryZLAWm+P6UthYOEH6YPO1rVhyoIBbjKR40AOVrkP4wNLZYGClkCxNKVSR5cpugWTfQfYHViy87WwePbetoR6RfBkDBZCtn14pIG2exo9KHJaP2+3EdSdTjr6vs24PtJUk5ZlyIHgpQyIoP3rsi8TD208clRfzJfDAvMwcKR/15D4+R9u4Wil62YFM98RoPQj3RnkRwbIseZto6MvOGUXodZcV5bnZAzDXi6wN+yTmK5bmqYg8zEiZ9i5KzVL1sVtXbxpJZUPgjbC4ZlNRh5fl+G61gwIDAQABAoIBAEErnTS4UOkAMiyiOgOTkGFlKG1+wMMS0iexL05ytVNLGkTcV29c2Jk8AesxS64Hpt6iVKnCHgxYB2hmAXPSOzp6qGpeGSval2uFZF6Py9v5Zt3are58huOXCd9kbUoYUOlu76XHGuCPICEPIM395xNVjyZ2awjPAt0v/0M3RMRcI2cDd4D3iHFqzUldQhvqWWrBEiRn4kfFb6IgkFrgrKoi9w52pefpIrlpmbPHS31Dn9k0bN4wjyUz3rNw40PcdYQP3R97yCrfRB9npZit3QCvD+Sb+RJpYrAtpLKmurmMZs3xOh6A1eaFZyB54bFnZjB696rACK/5A+FaAk/xDgkCgYEA6u8fWpHY+dBhr//6pyi14tFw4/AQe6JY2P7DMpM2PHAFFJLER2eIdC4Zd2vg4e7bLXKk0O1C5jqo0HZto9ie1fYNsaJA8o+K6htSjI2uN214iDfpfEZysIueBGMmX6TPOH+sxR35ZjJwJEmKV8//a85Z7Ifwd+a/aCMAsrOtGmkCgYEAu6jMWbQ7ir1qZKCmXgk6eyc4ZWLSGh35h/SevHNNGJRFJyMCOyKPc7PRe3e1kVuLoAVCYg/8WFIgZiCMwPUNdvvWwhpx0f00VAzGoycX4rORG1Pa/YoPK9dV51FgfNu92WQI9s2DWrW932i5hL8Go0+F0cvgZCwigaeK7N7ZmwsCgYEAp4iUVFLzZtpJ/2dMyI2If1IZ7gIQzwmr0DqE2nkOUTUU+mHbJIxZS3hgYsAEYzmhBRzfGbpIXcPxBI+fihr80dmgVE8/f3oLdvy69k5GsXIYZRNyJlRajzlRGxHVmJj/yOuLOhow8sb/H3Ft/Ubvf2Jsz/b07ZwYXNuxML5esBkCgYA6Fk/a3H0pvuP17fxRU0303PkJ+QLL7sdUnBWeg5ozp4GYUa/ZGiOJTvni2/Up30pi5/3aWNRlilZZBm5LNA9M6ztYrdLZiyTtd17tFabBF5AtA1Hf9SIpEeiXR4s0WthzOBHGQ2sLYwI46zOxsWeemXj0rcTxfO/ZbkEEfR6ibQKBgQCzd4AfOAe/71euMkb4HZ7JRo1VWqQ/FTcPZDWFyyDyIbNBNAMSd8ucHPQps4dzBtFcrMWeunp6QKB+MhwrrlifQqoZlrHbeKsJYjmJOPQoVmkiXNkD4ooIqizQun4bCZCNNuwafUiWtgNlCbZuk0+s6iWkUQXMitzvL+EakxmsAQ==
f7fea552-131d-4470-97ce-112836f8ad2d	67a54da7-6ccb-4b11-b0e3-b4ef264c223c	secret	DbUbvuI_6Pox0FdYlRg9y-8FexSZv6bo4_wtpbTj0_bVwllLwajPCO1545D84enfkBJ-OJcpdoC81DDBKQ_kgPnQw3Liu92XW2bDZeMzyr0L2A-Br5WGfgz4_0ll5MX6KjY3GPb8-W7mMqHeCnCygPOXGnBvjxYtyPgHDtTiMO4
b26c3a42-90cf-4aab-aecb-c48fe03cc337	67a54da7-6ccb-4b11-b0e3-b4ef264c223c	algorithm	HS512
9bcb0d75-993c-4b9c-ae5f-b4ab1dc30860	67a54da7-6ccb-4b11-b0e3-b4ef264c223c	priority	100
56b65ed5-ae8d-4815-8aa3-2f782facfd1c	67a54da7-6ccb-4b11-b0e3-b4ef264c223c	kid	92ab339d-dcff-4b0e-a0fc-b48f1acd91e1
4c4c8bda-830c-44a1-902c-c2dde774785d	c2cdc4ce-95e9-41d2-ac82-4fb157b4f3a7	certificate	MIICozCCAYsCBgGSq/6I1TANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDDApGZG9UZXN0YmVkMB4XDTI0MTAyMDIyMTIxOFoXDTM0MTAyMDIyMTM1OFowFTETMBEGA1UEAwwKRmRvVGVzdGJlZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJhKEYbenUO8txI32BQFMiHo3GimJMpyOHW13sXA5nT7BxHRPOF8Uupl9CHqS/CE6+TTkh/BjGlrErjN3a5OyOiCmYdzhAImWMdqiQCa18XYGr9JNtDcRovVe/yxjQ8T/0FsByFs+vkr1B+VSsi2BtS3/XWhTbbpZbLuH11wsbhV3j0Jd8JZRgbh6ESEHbh7+LxP7LivrkzcJZLsIzDgD2V0OhGMJ0Y/T7Aeu3l02y5DazfeTzUKNNzHpznZueeSuKmxaIC4S7lV6qllNtIgcINiT2M9mygmFm6w3h9xXoAmtdsLb23s/GAnAQIrx3C4f+2M/eqTlPGmZRaTRmQszBECAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAYRIhXEFElEHafQlgMhemtEKHJHzNsInKmTGa3SpqJNLfIWwi4z7z2Y0NiHZPFxqopEVypJiNjqcgJ5ldA5fuoLkYL74MrMtygQd59uQ0wJqJXF3KnqDrj5azUk76WZrd/Nc0SrB3rW6dC2YtW0rb0HcvV4ohp062r5dC+BO0cvTuUhb9YIZy2oyJ/7xNRqOmu+/puSHPBHQqhfcUi5mH0Z0LkDcUtWf6Lb4NpY1vB1HnUNUzg5nRl/1Y9PEsIWdWjw/h3jM9ILNUE1M2estU4W6UguV0reEv/z3NALxbfKJivwz0IJf96IOvjOL8mLqpAwaZUt6ap2QpsO4EkCmBlQ==
be355104-51dd-42ac-a638-0e8b0cc675f6	c2cdc4ce-95e9-41d2-ac82-4fb157b4f3a7	privateKey	MIIEogIBAAKCAQEAmEoRht6dQ7y3EjfYFAUyIejcaKYkynI4dbXexcDmdPsHEdE84XxS6mX0IepL8ITr5NOSH8GMaWsSuM3drk7I6IKZh3OEAiZYx2qJAJrXxdgav0k20NxGi9V7/LGNDxP/QWwHIWz6+SvUH5VKyLYG1Lf9daFNtullsu4fXXCxuFXePQl3wllGBuHoRIQduHv4vE/suK+uTNwlkuwjMOAPZXQ6EYwnRj9PsB67eXTbLkNrN95PNQo03MenOdm555K4qbFogLhLuVXqqWU20iBwg2JPYz2bKCYWbrDeH3FegCa12wtvbez8YCcBAivHcLh/7Yz96pOU8aZlFpNGZCzMEQIDAQABAoIBADg1ool60mYlmhbV2OHu1wWwGuZfaJX2mcNMuSiZnhZQb1gSuFtr1Xjh373C6nugvCbuNnGVMVvZowPmLGwBdWNojP1zVCas+7jDKEU6YekK7jhrcBmgLEPBrO1kpXGKynzdwDYEsQ/WLwnnQz6Y/SV3scxAmNwqApkMDjShe19TdJDNgPltwhjF3gZzkAwsv2sDWwNeieJxiupEjMNKjRRN3464VAyLBol6BFd4/T9S03qFUSzhreF801k8epA9Wbf7IuORazGQPQ98lYfIgN7R5V/9lLKuRb0hcNjcKswRPrCBPO/VvCf8PMdEWaUqt70sEGPkD8dD5kDDAKQ+gUcCgYEAyqaYXPeu7YbtOULnWfBWtYCtqIQXYXMQsldg07ki0m1L6RL46ZGdv737DWKJ0xuxXI0fj4mKhLV+PyYPSFBcBDhGxiiNAhcXk3xFwVAvXwQi61XDWcmYqSa8w4Vo379n2CXMYP+sMu+oq7V3X0B05YFKLCzXyiPG4H3xrn4XhjcCgYEAwGFszhNQ4u6J/gAhOmvTdaSOoRM50R0A5XPnpc5uxAxgg54jSOoZ+IBpqwPm7Ecq9Bgr2Q0n6hKx9BdTzyoHWegHOSABsB7obPLYcjptDZamOubFM/Eg9iSOcrlZM0F/ybwrHlCtQNHeqGdFsVlvDZrzUYA4Q3rYxr0pUUEBm/cCgYB1zIGlCRVWXahoMMvrLBo7R6Gq453zt79s6/4NFQF48K+/vJeUrmDUpMra7PzRCrf+5MoD1h//JMFOVAFuN8hFa7E4XzoYjPPXd9XUmZfv06e4xRHZj6Z+LVZtEY/1AH6M1uwHNpgSw914cvQBGqbZAl7rbuXBSyrANHXYyNND4QKBgG21oZUL0u73Vd5yOIDWiOroAya8jhZA0ggIRyx5QxWucUPd5QVp65GZuaj7Oq+4DjjRp//Jzt9f9ffbbcIQl8yf066yIAROPAIVo3XQ9+vt47JndEKg2klEo6+tH79pNPTYyEYrgAIdLTsgWdA/zmMV4Hi0BGIHJqR/r5ZU2hQVAoGAH2T5EZLbQF7rAnNnx95/lzReeB5Qs8uPpXRck+yAVs7h0JEH1FiXBTDpW+JHAeerDtUgASFkN3/RGct1/8pOwqLTf0nLeKbH7uuwOTm0xpbvd1EvXNbYjmH6Kw4HHV7RGncd5Q+9SNOXQUDpsYdiygJddZZxo9Rivc8Zsg8lEbQ=
12af14a2-456b-481c-9190-5f692eb4dd42	c2cdc4ce-95e9-41d2-ac82-4fb157b4f3a7	keyUse	ENC
db2027ad-58ac-4822-8aea-4f10363a8181	c2cdc4ce-95e9-41d2-ac82-4fb157b4f3a7	priority	100
a808b837-d6a2-407f-9e8f-f168fcf62666	c2cdc4ce-95e9-41d2-ac82-4fb157b4f3a7	algorithm	RSA-OAEP
7b904a79-b766-4ff6-808d-72b24ba51399	51053694-38cc-4b4b-98dc-db072ae1596f	client-uris-must-match	true
46b8394a-73c4-4187-bc2e-878d2728a901	51053694-38cc-4b4b-98dc-db072ae1596f	host-sending-registration-request-must-match	true
a1067d63-8e1e-4491-93bb-c6f1c8ed6984	a77819a2-7727-4e8d-bd67-7310d638950a	max-clients	200
a788a47f-a87e-4384-a98b-65f49248ea64	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	saml-user-attribute-mapper
88a95791-b9bf-411e-9728-bde5f4a92bdc	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	oidc-address-mapper
6b0b30e2-31dc-4933-a631-20c433db1707	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	saml-user-property-mapper
48a68380-80c8-4b7f-b801-d089cb6b4385	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
d9481d8f-1bf1-4daa-acad-abeae9511f0c	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
2af40d1d-f5a3-4598-b341-eaf13c683a8c	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	saml-role-list-mapper
228f595b-01e2-43c8-bfef-6983a29b1639	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	oidc-full-name-mapper
08e227dc-7b30-402c-b73f-ac6482c7c26d	a73ac6cb-54a9-4e55-a17d-e0b011867619	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
9ef7b3ae-8066-45d4-b96d-86f5e078bcb6	31d92787-49c4-4794-b404-e5e93be5db8a	allow-default-scopes	true
4f09e894-364f-4161-a4df-73f49409466a	00db9820-21e1-4fa7-a2a8-5010cb6330fb	allow-default-scopes	true
dd144bb0-c86c-42f0-b6a8-b237f0af0463	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
d5822c58-2778-46f1-956c-cd751e31dd4b	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	saml-user-property-mapper
b6034d27-aada-42bc-93d5-7ada149aeafb	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
be626c4c-1360-44ee-bcda-6cd9ba223102	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	saml-role-list-mapper
05c1233d-8588-4ef5-b04a-748978cce34f	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	oidc-address-mapper
693fe702-826f-4417-a3cc-05c601e87bcc	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
0c33e02b-e947-4234-909a-563552136529	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	saml-user-attribute-mapper
cdb0a840-cdfd-4efd-8441-06cbd930aef7	f32a0288-45fa-4568-8d11-c4a105adcbd0	allowed-protocol-mapper-types	oidc-full-name-mapper
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.composite_role (composite, child_role) FROM stdin;
206480c7-6f60-4253-93eb-f45856d65148	d31faf7f-314f-4858-88c1-ef02ae874a5e
206480c7-6f60-4253-93eb-f45856d65148	63e3eeee-5c53-4844-9f3e-0bad24fa6b59
206480c7-6f60-4253-93eb-f45856d65148	8c7c747e-c41c-47bf-8068-6283e986d98a
206480c7-6f60-4253-93eb-f45856d65148	709e4a5e-b418-46af-8948-f51100c45e67
206480c7-6f60-4253-93eb-f45856d65148	d6e63140-b9b2-473c-8e75-2e1cf02c9b9f
206480c7-6f60-4253-93eb-f45856d65148	750260ff-cf96-4428-887b-788b4749c6fb
206480c7-6f60-4253-93eb-f45856d65148	8250f9a1-01a2-4e90-8b94-e7b25f7a0d69
206480c7-6f60-4253-93eb-f45856d65148	84ad4c46-1eea-4c5f-bb99-65a959b47272
206480c7-6f60-4253-93eb-f45856d65148	10bd140f-18f0-4396-9b38-cdf407ff95c2
206480c7-6f60-4253-93eb-f45856d65148	4a9af589-8fc9-42b3-9f0b-6c3b7754138b
206480c7-6f60-4253-93eb-f45856d65148	60c0c971-e3b1-46fa-bb86-9a63990c94b3
206480c7-6f60-4253-93eb-f45856d65148	b0c0788e-ced9-4272-bb3c-8bfab2db21e7
206480c7-6f60-4253-93eb-f45856d65148	047e8244-f5cd-4716-9a9a-820b0f62657e
206480c7-6f60-4253-93eb-f45856d65148	caf69d1e-7679-44b9-9cef-7265b1495cfe
206480c7-6f60-4253-93eb-f45856d65148	6008398c-2981-49f9-b515-7ba42fa0193a
206480c7-6f60-4253-93eb-f45856d65148	08892fd7-9784-428d-bf45-eb1d5af9f6b6
206480c7-6f60-4253-93eb-f45856d65148	8b0f315e-59b4-430a-955b-46a425aad759
206480c7-6f60-4253-93eb-f45856d65148	8bce0073-5c36-4fb2-be04-b9dd9e058ee9
52491b27-eaac-40f8-84a4-9398ba7fbd95	a46d6f0e-22d2-457f-b01d-4cbf971b1bdb
709e4a5e-b418-46af-8948-f51100c45e67	8bce0073-5c36-4fb2-be04-b9dd9e058ee9
709e4a5e-b418-46af-8948-f51100c45e67	6008398c-2981-49f9-b515-7ba42fa0193a
d6e63140-b9b2-473c-8e75-2e1cf02c9b9f	08892fd7-9784-428d-bf45-eb1d5af9f6b6
52491b27-eaac-40f8-84a4-9398ba7fbd95	2dc4af82-d9cd-4e18-b7af-9e7e361a0d95
2dc4af82-d9cd-4e18-b7af-9e7e361a0d95	33f5a6d1-2a85-4960-a208-be300152f275
8663f184-303b-42ad-aa60-cebb43693d80	a064d498-1dbc-4fbe-9210-372b3f48a1bb
206480c7-6f60-4253-93eb-f45856d65148	f6b8aae3-6e25-4104-b80e-243c21aa0648
52491b27-eaac-40f8-84a4-9398ba7fbd95	ba676c22-696b-4d11-832b-7b9a507f75cd
52491b27-eaac-40f8-84a4-9398ba7fbd95	0e5f0ff7-b0f6-44df-96b7-189684f5f3d6
206480c7-6f60-4253-93eb-f45856d65148	f175d2d4-6249-498a-8f10-abb078506525
206480c7-6f60-4253-93eb-f45856d65148	adc58140-faa7-4b54-85d3-7dbfb3c545dc
206480c7-6f60-4253-93eb-f45856d65148	b1a36a01-ad81-4bfe-a188-2098891c1358
206480c7-6f60-4253-93eb-f45856d65148	8f79afef-ed0f-4d46-9872-513a4b05286a
206480c7-6f60-4253-93eb-f45856d65148	3bdeb514-b3f8-4473-ab8b-4dcca4d01e6f
206480c7-6f60-4253-93eb-f45856d65148	d253e42a-cd54-4dd2-9c52-aa50cf2aa124
206480c7-6f60-4253-93eb-f45856d65148	ac79f334-f842-495a-8aad-e07706fea3db
206480c7-6f60-4253-93eb-f45856d65148	1f367201-7a28-4719-9116-4f3abf83e1c2
206480c7-6f60-4253-93eb-f45856d65148	b760fa4d-fbcd-4ae0-8858-67f38a33652a
206480c7-6f60-4253-93eb-f45856d65148	3a9abc78-ad67-4910-a934-ec8bda2b0327
206480c7-6f60-4253-93eb-f45856d65148	bdabcb88-27a1-49c6-aed8-192f9ae024c7
206480c7-6f60-4253-93eb-f45856d65148	88719ec9-4b5e-4a77-af2c-4cc4695426a9
206480c7-6f60-4253-93eb-f45856d65148	b01110ac-5555-4c60-92bb-67ab7317ee92
206480c7-6f60-4253-93eb-f45856d65148	85a6ed1e-b924-48f9-8986-49fc7a256b67
206480c7-6f60-4253-93eb-f45856d65148	32e1abca-af43-4a93-a8fb-70ed304d4c2d
206480c7-6f60-4253-93eb-f45856d65148	f5707350-46ed-46ea-9c9a-42cfe24eec1a
206480c7-6f60-4253-93eb-f45856d65148	ebaebc36-dda3-44bd-a49d-67d82f662157
8f79afef-ed0f-4d46-9872-513a4b05286a	32e1abca-af43-4a93-a8fb-70ed304d4c2d
b1a36a01-ad81-4bfe-a188-2098891c1358	ebaebc36-dda3-44bd-a49d-67d82f662157
b1a36a01-ad81-4bfe-a188-2098891c1358	85a6ed1e-b924-48f9-8986-49fc7a256b67
cb49a6a7-c904-422e-8653-3f137bf3e1e5	a0d295d3-97c6-4b39-9f5b-366a7ab2880f
cb49a6a7-c904-422e-8653-3f137bf3e1e5	c270538c-1f6f-407d-8429-266dc2540ed0
cb49a6a7-c904-422e-8653-3f137bf3e1e5	26277d02-f79c-4b24-95b7-cc9ab4e9481b
cb49a6a7-c904-422e-8653-3f137bf3e1e5	cc6a1227-b02a-405f-8424-d59641431bf8
cb49a6a7-c904-422e-8653-3f137bf3e1e5	eb123573-d636-4a1e-9dfe-37fa6fb1ef5a
cb49a6a7-c904-422e-8653-3f137bf3e1e5	777a7585-55b7-4c37-8c05-d18bd6fe71b5
cb49a6a7-c904-422e-8653-3f137bf3e1e5	b2deafff-da95-494d-b084-0b530e8df066
cb49a6a7-c904-422e-8653-3f137bf3e1e5	0d85c0ac-b229-470d-a966-fba6a8301491
cb49a6a7-c904-422e-8653-3f137bf3e1e5	08f93853-ceda-419e-a8ef-14469e452ecf
cb49a6a7-c904-422e-8653-3f137bf3e1e5	5262c325-3fef-4cb7-ad61-266219d8d8e8
cb49a6a7-c904-422e-8653-3f137bf3e1e5	91267d17-8e8c-4b2b-9cd0-259e84af6bbd
cb49a6a7-c904-422e-8653-3f137bf3e1e5	a96617cc-c299-49ca-9fa9-ead6633c7533
cb49a6a7-c904-422e-8653-3f137bf3e1e5	bf2c6c7f-b890-4d5f-8300-b928a50f0af9
cb49a6a7-c904-422e-8653-3f137bf3e1e5	f32c8ecb-0c2f-4ea3-bba2-d97496d0fa7a
cb49a6a7-c904-422e-8653-3f137bf3e1e5	3ab5d53e-6518-439a-ad41-70c8dfef2512
cb49a6a7-c904-422e-8653-3f137bf3e1e5	102455b6-3fde-4a0c-948c-8771863d03d5
cb49a6a7-c904-422e-8653-3f137bf3e1e5	ac8f0fe0-9acc-4f53-8f09-2fb8d43f2ab1
26277d02-f79c-4b24-95b7-cc9ab4e9481b	ac8f0fe0-9acc-4f53-8f09-2fb8d43f2ab1
26277d02-f79c-4b24-95b7-cc9ab4e9481b	f32c8ecb-0c2f-4ea3-bba2-d97496d0fa7a
b831367a-109f-4dc3-95c2-e2c2bd8a4ba6	14305fd4-8a81-49fa-b0ea-5a27549de074
cc6a1227-b02a-405f-8424-d59641431bf8	3ab5d53e-6518-439a-ad41-70c8dfef2512
b831367a-109f-4dc3-95c2-e2c2bd8a4ba6	11c7e4a5-08ce-4856-801e-182b107e63cc
11c7e4a5-08ce-4856-801e-182b107e63cc	23636220-21e1-47cb-bff4-41698e5b9c34
5b8a9165-1270-40ac-a274-de3b3dd328e1	51a41e62-a909-4766-9da1-13de37dfa837
206480c7-6f60-4253-93eb-f45856d65148	7dd25e64-1e91-4fb2-9b73-4322648fb0ab
cb49a6a7-c904-422e-8653-3f137bf3e1e5	7db5d158-2819-4c87-9959-8adeab9149cc
b831367a-109f-4dc3-95c2-e2c2bd8a4ba6	c09e84c1-5a5d-43a8-86b6-010770c15dcf
b831367a-109f-4dc3-95c2-e2c2bd8a4ba6	81dd29ba-7f8d-4dec-9926-20e7f8d83218
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
48fa0363-8e67-48e0-a006-3d9ee715ce67	\N	password	e0d3593f-af63-4fd0-bd55-850919e319b9	1729463586484	My password	{"value":"xtH4cDNkvyj97YYpbM2z/afU3oxzC5GNDDRZBlp8NuA=","salt":"36/WrH0WIDuiL5FHHD2Brw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
d674b50a-3e6a-4afe-a05e-64940bfb73a3	\N	password	d75c86b5-9c77-45cb-b277-232022f9a826	1730061175926	\N	{"value":"AhZT3pMQSXmV5ZtodmxX/iPqxRkI+H/i38omV9nQ4TI=","salt":"SseNbbYokrdIcfkebHEQpA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2024-10-20 22:11:57.190921	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	9462316514
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2024-10-20 22:11:57.219037	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	9462316514
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2024-10-20 22:11:57.272083	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.29.1	\N	\N	9462316514
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2024-10-20 22:11:57.276625	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	9462316514
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2024-10-20 22:11:57.413118	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	9462316514
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2024-10-20 22:11:57.420599	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	9462316514
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2024-10-20 22:11:57.53287	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	9462316514
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2024-10-20 22:11:57.539712	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	9462316514
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2024-10-20 22:11:57.547078	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.29.1	\N	\N	9462316514
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2024-10-20 22:11:57.687676	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.29.1	\N	\N	9462316514
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2024-10-20 22:11:57.764439	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	9462316514
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2024-10-20 22:11:57.772499	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	9462316514
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2024-10-20 22:11:57.805561	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	9462316514
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-10-20 22:11:57.832233	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.29.1	\N	\N	9462316514
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-10-20 22:11:57.83421	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9462316514
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-10-20 22:11:57.838247	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.29.1	\N	\N	9462316514
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-10-20 22:11:57.842121	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.29.1	\N	\N	9462316514
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2024-10-20 22:11:57.905285	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.29.1	\N	\N	9462316514
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2024-10-20 22:11:57.965433	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	9462316514
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2024-10-20 22:11:57.971216	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	9462316514
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.244287	144	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.29.1	\N	\N	9462316514
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2024-10-20 22:11:57.975161	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	9462316514
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2024-10-20 22:11:57.97803	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	9462316514
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2024-10-20 22:11:58.100201	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.29.1	\N	\N	9462316514
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2024-10-20 22:11:58.107622	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	9462316514
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2024-10-20 22:11:58.109409	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	9462316514
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2024-10-20 22:11:58.690379	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.29.1	\N	\N	9462316514
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2024-10-20 22:11:58.805068	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.29.1	\N	\N	9462316514
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2024-10-20 22:11:58.811157	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	9462316514
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2024-10-20 22:11:58.92375	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.29.1	\N	\N	9462316514
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2024-10-20 22:11:58.947905	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.29.1	\N	\N	9462316514
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2024-10-20 22:11:58.978353	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.29.1	\N	\N	9462316514
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2024-10-20 22:11:58.983747	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.29.1	\N	\N	9462316514
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-10-20 22:11:58.990313	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9462316514
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-10-20 22:11:58.992572	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	9462316514
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-10-20 22:11:59.023927	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	9462316514
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2024-10-20 22:11:59.029373	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.29.1	\N	\N	9462316514
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-10-20 22:11:59.035778	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	9462316514
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2024-10-20 22:11:59.039968	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.29.1	\N	\N	9462316514
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2024-10-20 22:11:59.043743	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.29.1	\N	\N	9462316514
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-10-20 22:11:59.04531	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	9462316514
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-10-20 22:11:59.047476	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	9462316514
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2024-10-20 22:11:59.057446	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.29.1	\N	\N	9462316514
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-10-20 22:12:00.631314	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.29.1	\N	\N	9462316514
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2024-10-20 22:12:00.635303	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.29.1	\N	\N	9462316514
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-10-20 22:12:00.63968	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	9462316514
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-10-20 22:12:00.644101	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.29.1	\N	\N	9462316514
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-10-20 22:12:00.645537	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	9462316514
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-10-20 22:12:00.805062	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.29.1	\N	\N	9462316514
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-10-20 22:12:00.80878	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.29.1	\N	\N	9462316514
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2024-10-20 22:12:00.852478	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.29.1	\N	\N	9462316514
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2024-10-20 22:12:01.172672	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.29.1	\N	\N	9462316514
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2024-10-20 22:12:01.175783	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2024-10-20 22:12:01.178103	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.29.1	\N	\N	9462316514
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2024-10-20 22:12:01.180322	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.29.1	\N	\N	9462316514
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-10-20 22:12:01.186356	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.29.1	\N	\N	9462316514
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-10-20 22:12:01.192784	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.29.1	\N	\N	9462316514
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-10-20 22:12:01.238409	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.29.1	\N	\N	9462316514
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-10-20 22:12:01.600868	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.29.1	\N	\N	9462316514
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2024-10-20 22:12:01.628529	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.29.1	\N	\N	9462316514
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2024-10-20 22:12:01.63526	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	9462316514
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-10-20 22:12:01.644163	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.29.1	\N	\N	9462316514
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-10-20 22:12:01.649792	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.29.1	\N	\N	9462316514
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2024-10-20 22:12:01.653224	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	9462316514
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2024-10-20 22:12:01.656336	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	9462316514
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2024-10-20 22:12:01.659498	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.29.1	\N	\N	9462316514
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2024-10-20 22:12:01.723502	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.29.1	\N	\N	9462316514
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2024-10-20 22:12:01.773134	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.29.1	\N	\N	9462316514
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2024-10-20 22:12:01.778423	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.29.1	\N	\N	9462316514
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2024-10-20 22:12:01.826719	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.29.1	\N	\N	9462316514
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2024-10-20 22:12:01.831506	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.29.1	\N	\N	9462316514
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2024-10-20 22:12:01.835425	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	9462316514
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-10-20 22:12:01.842066	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	9462316514
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-10-20 22:12:01.849128	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	9462316514
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-10-20 22:12:01.851084	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	9462316514
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-10-20 22:12:01.875764	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.29.1	\N	\N	9462316514
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-10-20 22:12:01.91091	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.29.1	\N	\N	9462316514
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-10-20 22:12:01.914534	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.29.1	\N	\N	9462316514
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-10-20 22:12:01.915872	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.29.1	\N	\N	9462316514
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-10-20 22:12:01.937529	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.29.1	\N	\N	9462316514
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-10-20 22:12:01.939125	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.29.1	\N	\N	9462316514
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-10-20 22:12:01.97306	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.29.1	\N	\N	9462316514
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-10-20 22:12:01.974483	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	9462316514
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-10-20 22:12:01.978386	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	9462316514
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-10-20 22:12:01.979625	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	9462316514
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-10-20 22:12:02.01313	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	9462316514
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2024-10-20 22:12:02.019328	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.29.1	\N	\N	9462316514
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-10-20 22:12:02.030241	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.29.1	\N	\N	9462316514
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-10-20 22:12:02.03949	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.29.1	\N	\N	9462316514
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.045224	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.29.1	\N	\N	9462316514
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.054043	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.29.1	\N	\N	9462316514
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.08672	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9462316514
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.099018	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.29.1	\N	\N	9462316514
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.100493	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	9462316514
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.11165	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	9462316514
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.113408	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.29.1	\N	\N	9462316514
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-10-20 22:12:02.119568	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.29.1	\N	\N	9462316514
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-10-20 22:12:02.214633	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9462316514
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-10-20 22:12:02.216315	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-10-20 22:12:02.226336	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-10-20 22:12:02.265574	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-10-20 22:12:02.267337	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-10-20 22:12:02.308337	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.29.1	\N	\N	9462316514
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-10-20 22:12:02.31372	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.29.1	\N	\N	9462316514
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2024-10-20 22:12:02.321018	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.29.1	\N	\N	9462316514
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2024-10-20 22:12:02.366552	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.29.1	\N	\N	9462316514
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2024-10-20 22:12:02.412072	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	9462316514
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2024-10-20 22:12:02.46604	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.29.1	\N	\N	9462316514
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2024-10-20 22:12:02.471176	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.29.1	\N	\N	9462316514
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-10-20 22:12:02.523449	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	9462316514
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-10-20 22:12:02.525323	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	9462316514
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-10-20 22:12:02.532346	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2024-10-20 22:12:02.537061	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.29.1	\N	\N	9462316514
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-10-20 22:12:02.565195	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	9462316514
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-10-20 22:12:02.568159	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.29.1	\N	\N	9462316514
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-10-20 22:12:02.573822	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.29.1	\N	\N	9462316514
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-10-20 22:12:02.576055	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.29.1	\N	\N	9462316514
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-10-20 22:12:02.58269	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.29.1	\N	\N	9462316514
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-10-20 22:12:02.586215	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	9462316514
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-10-20 22:12:02.728908	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.29.1	\N	\N	9462316514
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-10-20 22:12:02.732912	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.29.1	\N	\N	9462316514
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-10-20 22:12:02.737576	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-10-20 22:12:02.76959	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2024-10-20 22:12:02.772758	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.29.1	\N	\N	9462316514
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2024-10-20 22:12:02.774036	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2024-10-20 22:12:02.775522	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	9462316514
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.780166	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	9462316514
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.814491	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9462316514
25.0.0-28265-index-cleanup	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.819398	128	EXECUTED	9:8c0cfa341a0474385b324f5c4b2dfcc1	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION; dropIndex ...		\N	4.29.1	\N	\N	9462316514
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.820654	129	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9462316514
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.854677	130	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9462316514
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.875703	131	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	9462316514
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.901148	132	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	9462316514
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:02.904523	133	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	9462316514
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-10-20 22:12:03.00366	134	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.29.1	\N	\N	9462316514
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.010231	135	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.29.1	\N	\N	9462316514
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.015689	136	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.29.1	\N	\N	9462316514
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.047604	137	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	9462316514
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.051447	138	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.29.1	\N	\N	9462316514
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.057516	139	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	9462316514
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.089248	140	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	9462316514
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.157726	141	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.29.1	\N	\N	9462316514
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.218085	142	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	9462316514
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2024-10-20 22:12:03.240827	143	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.29.1	\N	\N	9462316514
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
8fb72edd-3595-407b-9597-900a93b73829	357233d2-4de7-45a5-b6d0-98a7f2127f19	f
8fb72edd-3595-407b-9597-900a93b73829	562b910d-58cd-4605-aac7-f7d62e644c7b	t
8fb72edd-3595-407b-9597-900a93b73829	d4b92a48-9fd2-4597-80bd-7881fff42353	t
8fb72edd-3595-407b-9597-900a93b73829	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2	t
8fb72edd-3595-407b-9597-900a93b73829	abdaf343-7b51-44c1-8123-f45faf6faf9e	t
8fb72edd-3595-407b-9597-900a93b73829	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7	f
8fb72edd-3595-407b-9597-900a93b73829	431c73c1-540b-40dc-937a-0d6cd14fe49b	f
8fb72edd-3595-407b-9597-900a93b73829	eb82c1ec-2fbd-456e-8249-65b528de8f54	t
8fb72edd-3595-407b-9597-900a93b73829	d92928fc-caad-4643-9a48-cdab53080206	t
8fb72edd-3595-407b-9597-900a93b73829	383fc2af-efff-4e69-b6de-96317ddff877	f
8fb72edd-3595-407b-9597-900a93b73829	77715671-f192-4f2c-9f92-76c8d24d12e6	t
8fb72edd-3595-407b-9597-900a93b73829	4c3ceb89-085e-4b44-95b3-f17940951afe	t
8fb72edd-3595-407b-9597-900a93b73829	167ecda7-dfc5-4059-b1aa-a7c424f0c295	f
106128c4-abe4-410c-82af-b8d094c1c313	186249ad-586f-4609-af37-92c9de6c587d	f
106128c4-abe4-410c-82af-b8d094c1c313	6e3e7365-c3c3-4793-9cda-8acdf6905956	t
106128c4-abe4-410c-82af-b8d094c1c313	541e36b2-fa22-428d-935d-d69ab382fa45	t
106128c4-abe4-410c-82af-b8d094c1c313	d609acfd-2a2d-4cc3-beae-7e57214766b0	t
106128c4-abe4-410c-82af-b8d094c1c313	9a8bde13-3625-43a2-abe3-ff373fdaa243	t
106128c4-abe4-410c-82af-b8d094c1c313	3d914493-56ec-4fd5-bb7a-6523e38cdda0	f
106128c4-abe4-410c-82af-b8d094c1c313	fe1dc014-a6b3-4b37-a8da-b259dd1cd057	f
106128c4-abe4-410c-82af-b8d094c1c313	b19b596e-bd20-46c4-aa1f-20e02d39f33b	t
106128c4-abe4-410c-82af-b8d094c1c313	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef	t
106128c4-abe4-410c-82af-b8d094c1c313	004c569d-07a9-401b-b218-5cec626a0c28	f
106128c4-abe4-410c-82af-b8d094c1c313	92e20777-eba7-4271-919d-af54d5b790dc	t
106128c4-abe4-410c-82af-b8d094c1c313	e23685c8-91dd-48ed-8d80-4ee85e2d62ef	t
106128c4-abe4-410c-82af-b8d094c1c313	772a7d75-ddc7-403b-8d0e-f17662bbda42	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
52491b27-eaac-40f8-84a4-9398ba7fbd95	8fb72edd-3595-407b-9597-900a93b73829	f	${role_default-roles}	default-roles-master	8fb72edd-3595-407b-9597-900a93b73829	\N	\N
206480c7-6f60-4253-93eb-f45856d65148	8fb72edd-3595-407b-9597-900a93b73829	f	${role_admin}	admin	8fb72edd-3595-407b-9597-900a93b73829	\N	\N
d31faf7f-314f-4858-88c1-ef02ae874a5e	8fb72edd-3595-407b-9597-900a93b73829	f	${role_create-realm}	create-realm	8fb72edd-3595-407b-9597-900a93b73829	\N	\N
63e3eeee-5c53-4844-9f3e-0bad24fa6b59	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_create-client}	create-client	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
8c7c747e-c41c-47bf-8068-6283e986d98a	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_view-realm}	view-realm	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
709e4a5e-b418-46af-8948-f51100c45e67	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_view-users}	view-users	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
d6e63140-b9b2-473c-8e75-2e1cf02c9b9f	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_view-clients}	view-clients	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
750260ff-cf96-4428-887b-788b4749c6fb	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_view-events}	view-events	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
8250f9a1-01a2-4e90-8b94-e7b25f7a0d69	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_view-identity-providers}	view-identity-providers	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
84ad4c46-1eea-4c5f-bb99-65a959b47272	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_view-authorization}	view-authorization	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
10bd140f-18f0-4396-9b38-cdf407ff95c2	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_manage-realm}	manage-realm	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
4a9af589-8fc9-42b3-9f0b-6c3b7754138b	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_manage-users}	manage-users	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
60c0c971-e3b1-46fa-bb86-9a63990c94b3	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_manage-clients}	manage-clients	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
b0c0788e-ced9-4272-bb3c-8bfab2db21e7	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_manage-events}	manage-events	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
047e8244-f5cd-4716-9a9a-820b0f62657e	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_manage-identity-providers}	manage-identity-providers	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
caf69d1e-7679-44b9-9cef-7265b1495cfe	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_manage-authorization}	manage-authorization	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
6008398c-2981-49f9-b515-7ba42fa0193a	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_query-users}	query-users	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
08892fd7-9784-428d-bf45-eb1d5af9f6b6	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_query-clients}	query-clients	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
8b0f315e-59b4-430a-955b-46a425aad759	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_query-realms}	query-realms	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
8bce0073-5c36-4fb2-be04-b9dd9e058ee9	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_query-groups}	query-groups	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
a46d6f0e-22d2-457f-b01d-4cbf971b1bdb	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_view-profile}	view-profile	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
2dc4af82-d9cd-4e18-b7af-9e7e361a0d95	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_manage-account}	manage-account	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
33f5a6d1-2a85-4960-a208-be300152f275	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_manage-account-links}	manage-account-links	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
e59ea3d7-2497-4e3b-ada1-63c3bc4a0cc6	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_view-applications}	view-applications	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
a064d498-1dbc-4fbe-9210-372b3f48a1bb	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_view-consent}	view-consent	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
8663f184-303b-42ad-aa60-cebb43693d80	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_manage-consent}	manage-consent	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
49fd5038-149c-472e-9173-04d7e26946be	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_view-groups}	view-groups	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
72e64bec-f96b-4e79-ac7c-cca660d96fd2	e58cdd2a-c86d-4477-9182-8d2448818975	t	${role_delete-account}	delete-account	8fb72edd-3595-407b-9597-900a93b73829	e58cdd2a-c86d-4477-9182-8d2448818975	\N
d1c1136c-6776-45e7-a366-a6f5a9b2c3d5	a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	t	${role_read-token}	read-token	8fb72edd-3595-407b-9597-900a93b73829	a60d95d2-9bae-4c36-bdb4-e0e2d5674c63	\N
f6b8aae3-6e25-4104-b80e-243c21aa0648	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	t	${role_impersonation}	impersonation	8fb72edd-3595-407b-9597-900a93b73829	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	\N
ba676c22-696b-4d11-832b-7b9a507f75cd	8fb72edd-3595-407b-9597-900a93b73829	f	${role_offline-access}	offline_access	8fb72edd-3595-407b-9597-900a93b73829	\N	\N
0e5f0ff7-b0f6-44df-96b7-189684f5f3d6	8fb72edd-3595-407b-9597-900a93b73829	f	${role_uma_authorization}	uma_authorization	8fb72edd-3595-407b-9597-900a93b73829	\N	\N
b831367a-109f-4dc3-95c2-e2c2bd8a4ba6	106128c4-abe4-410c-82af-b8d094c1c313	f	${role_default-roles}	default-roles-fdotestbed	106128c4-abe4-410c-82af-b8d094c1c313	\N	\N
f175d2d4-6249-498a-8f10-abb078506525	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_create-client}	create-client	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
adc58140-faa7-4b54-85d3-7dbfb3c545dc	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_view-realm}	view-realm	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
b1a36a01-ad81-4bfe-a188-2098891c1358	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_view-users}	view-users	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
8f79afef-ed0f-4d46-9872-513a4b05286a	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_view-clients}	view-clients	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
3bdeb514-b3f8-4473-ab8b-4dcca4d01e6f	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_view-events}	view-events	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
d253e42a-cd54-4dd2-9c52-aa50cf2aa124	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_view-identity-providers}	view-identity-providers	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
ac79f334-f842-495a-8aad-e07706fea3db	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_view-authorization}	view-authorization	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
1f367201-7a28-4719-9116-4f3abf83e1c2	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_manage-realm}	manage-realm	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
b760fa4d-fbcd-4ae0-8858-67f38a33652a	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_manage-users}	manage-users	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
3a9abc78-ad67-4910-a934-ec8bda2b0327	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_manage-clients}	manage-clients	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
bdabcb88-27a1-49c6-aed8-192f9ae024c7	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_manage-events}	manage-events	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
88719ec9-4b5e-4a77-af2c-4cc4695426a9	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_manage-identity-providers}	manage-identity-providers	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
b01110ac-5555-4c60-92bb-67ab7317ee92	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_manage-authorization}	manage-authorization	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
85a6ed1e-b924-48f9-8986-49fc7a256b67	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_query-users}	query-users	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
32e1abca-af43-4a93-a8fb-70ed304d4c2d	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_query-clients}	query-clients	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
f5707350-46ed-46ea-9c9a-42cfe24eec1a	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_query-realms}	query-realms	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
ebaebc36-dda3-44bd-a49d-67d82f662157	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_query-groups}	query-groups	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
cb49a6a7-c904-422e-8653-3f137bf3e1e5	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_realm-admin}	realm-admin	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
a0d295d3-97c6-4b39-9f5b-366a7ab2880f	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_create-client}	create-client	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
c270538c-1f6f-407d-8429-266dc2540ed0	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_view-realm}	view-realm	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
26277d02-f79c-4b24-95b7-cc9ab4e9481b	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_view-users}	view-users	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
cc6a1227-b02a-405f-8424-d59641431bf8	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_view-clients}	view-clients	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
eb123573-d636-4a1e-9dfe-37fa6fb1ef5a	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_view-events}	view-events	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
777a7585-55b7-4c37-8c05-d18bd6fe71b5	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_view-identity-providers}	view-identity-providers	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
b2deafff-da95-494d-b084-0b530e8df066	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_view-authorization}	view-authorization	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
0d85c0ac-b229-470d-a966-fba6a8301491	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_manage-realm}	manage-realm	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
08f93853-ceda-419e-a8ef-14469e452ecf	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_manage-users}	manage-users	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
5262c325-3fef-4cb7-ad61-266219d8d8e8	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_manage-clients}	manage-clients	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
91267d17-8e8c-4b2b-9cd0-259e84af6bbd	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_manage-events}	manage-events	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
a96617cc-c299-49ca-9fa9-ead6633c7533	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_manage-identity-providers}	manage-identity-providers	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
bf2c6c7f-b890-4d5f-8300-b928a50f0af9	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_manage-authorization}	manage-authorization	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
f32c8ecb-0c2f-4ea3-bba2-d97496d0fa7a	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_query-users}	query-users	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
3ab5d53e-6518-439a-ad41-70c8dfef2512	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_query-clients}	query-clients	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
102455b6-3fde-4a0c-948c-8771863d03d5	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_query-realms}	query-realms	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
ac8f0fe0-9acc-4f53-8f09-2fb8d43f2ab1	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_query-groups}	query-groups	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
14305fd4-8a81-49fa-b0ea-5a27549de074	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_view-profile}	view-profile	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
11c7e4a5-08ce-4856-801e-182b107e63cc	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_manage-account}	manage-account	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
23636220-21e1-47cb-bff4-41698e5b9c34	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_manage-account-links}	manage-account-links	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
84b2595e-0839-47cc-830c-bb4116062c74	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_view-applications}	view-applications	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
51a41e62-a909-4766-9da1-13de37dfa837	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_view-consent}	view-consent	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
5b8a9165-1270-40ac-a274-de3b3dd328e1	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_manage-consent}	manage-consent	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
a0c8c17f-a296-431a-b495-fe5c02276198	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_view-groups}	view-groups	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
80462466-d2d6-43fa-8f69-f663956cb6c2	22a1d428-ec7b-4f91-a222-06c55a128831	t	${role_delete-account}	delete-account	106128c4-abe4-410c-82af-b8d094c1c313	22a1d428-ec7b-4f91-a222-06c55a128831	\N
7dd25e64-1e91-4fb2-9b73-4322648fb0ab	f17d49e1-1994-4c2a-9130-3e0353fabc06	t	${role_impersonation}	impersonation	8fb72edd-3595-407b-9597-900a93b73829	f17d49e1-1994-4c2a-9130-3e0353fabc06	\N
7db5d158-2819-4c87-9959-8adeab9149cc	6c5705d3-5e1e-4931-b897-d954d6da7b05	t	${role_impersonation}	impersonation	106128c4-abe4-410c-82af-b8d094c1c313	6c5705d3-5e1e-4931-b897-d954d6da7b05	\N
b2c9068e-b7db-4252-a7a3-def939a2464e	7eed5789-b554-45ae-b162-5f68d136ff21	t	${role_read-token}	read-token	106128c4-abe4-410c-82af-b8d094c1c313	7eed5789-b554-45ae-b162-5f68d136ff21	\N
c09e84c1-5a5d-43a8-86b6-010770c15dcf	106128c4-abe4-410c-82af-b8d094c1c313	f	${role_offline-access}	offline_access	106128c4-abe4-410c-82af-b8d094c1c313	\N	\N
81dd29ba-7f8d-4dec-9926-20e7f8d83218	106128c4-abe4-410c-82af-b8d094c1c313	f	${role_uma_authorization}	uma_authorization	106128c4-abe4-410c-82af-b8d094c1c313	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.migration_model (id, version, update_time) FROM stdin;
45i97	26.0.1	1729462323
k0g7d	26.0.2	1730058800
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
a7801948-8148-4847-91d0-3d3c1ac21080	audience resolve	openid-connect	oidc-audience-resolve-mapper	a1009637-d602-4178-8531-be4cd5eddbdd	\N
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	locale	openid-connect	oidc-usermodel-attribute-mapper	83e64015-a218-4024-8318-fb3ffe674c30	\N
6c0b6b23-952d-4cf9-a439-3afeed9961bc	role list	saml	saml-role-list-mapper	\N	562b910d-58cd-4605-aac7-f7d62e644c7b
77952557-00cc-4068-995f-007988179577	organization	saml	saml-organization-membership-mapper	\N	d4b92a48-9fd2-4597-80bd-7881fff42353
0cf87bc9-721a-4b0b-abfa-ca6c342a11ed	full name	openid-connect	oidc-full-name-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
ef3dc7be-3a95-43e7-ac80-ef1be1974575	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
570cd066-db79-4ef7-85fa-fc55568a93bb	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
87297115-78c9-4037-b43c-19430bb3f9e9	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
defe79cf-a23f-4f23-9f4c-8822b807be55	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	username	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
ef20f109-f113-4a5a-9123-562c197d3c2a	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
866871c6-5961-4b4f-a143-6b93ce5110fc	website	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
d0489e3b-183a-49cf-9f23-f58b11c085d0	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
80911a14-9522-4e54-8868-7eb83be74f9b	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	ee1b1f5f-fad9-440f-88e4-fa4a030b84c2
d4af1aa2-346f-42bc-9120-46ee8a943618	email	openid-connect	oidc-usermodel-attribute-mapper	\N	abdaf343-7b51-44c1-8123-f45faf6faf9e
62eb67f1-ad3d-40f1-9ef0-796eb607065d	email verified	openid-connect	oidc-usermodel-property-mapper	\N	abdaf343-7b51-44c1-8123-f45faf6faf9e
c0132bc9-b69d-44ad-9a05-4800c1ba1635	address	openid-connect	oidc-address-mapper	\N	bc8c4cd2-4af5-444e-b75d-3dc92bdd93e7
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	431c73c1-540b-40dc-937a-0d6cd14fe49b
286b0895-4fc2-456c-b1ed-4a0bc5836e90	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	431c73c1-540b-40dc-937a-0d6cd14fe49b
36b41ef8-842e-4511-9d75-8ee25428381f	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	eb82c1ec-2fbd-456e-8249-65b528de8f54
65598705-bb75-4545-b690-2db60d2242a7	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	eb82c1ec-2fbd-456e-8249-65b528de8f54
8fef025a-b26e-4357-9b24-77a2ec3581e2	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	eb82c1ec-2fbd-456e-8249-65b528de8f54
dbf92fb8-c2d8-468a-914d-614a943e9e65	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	d92928fc-caad-4643-9a48-cdab53080206
6abc9acd-959b-401f-89f5-bfef6aaf6315	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	383fc2af-efff-4e69-b6de-96317ddff877
68df7a8c-8b07-4cd6-8594-3459654787d2	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	383fc2af-efff-4e69-b6de-96317ddff877
746c9654-e45f-4bb1-a149-4a2e5978feea	acr loa level	openid-connect	oidc-acr-mapper	\N	77715671-f192-4f2c-9f92-76c8d24d12e6
388df0a1-1f3c-4a7c-99a5-e9027fb22283	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	4c3ceb89-085e-4b44-95b3-f17940951afe
1f44619f-9152-42e0-ab81-7a5d6754f742	sub	openid-connect	oidc-sub-mapper	\N	4c3ceb89-085e-4b44-95b3-f17940951afe
ca103b0a-c320-4f5a-b83a-12dd65c6f738	organization	openid-connect	oidc-organization-membership-mapper	\N	167ecda7-dfc5-4059-b1aa-a7c424f0c295
4106665e-b989-482a-ac31-17f1c4081c81	audience resolve	openid-connect	oidc-audience-resolve-mapper	1ef61626-bfd6-4c61-ba3c-e93a688b330f	\N
3fe6a42a-5a63-42e1-9922-a74ecb568f47	role list	saml	saml-role-list-mapper	\N	6e3e7365-c3c3-4793-9cda-8acdf6905956
65f05185-eadf-4b25-8fc3-548d26bfa8f9	organization	saml	saml-organization-membership-mapper	\N	541e36b2-fa22-428d-935d-d69ab382fa45
1d0dde3b-f089-4f10-9709-3963d84e5f14	full name	openid-connect	oidc-full-name-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
f04baad6-d3b0-44e3-8bec-853cd4525bff	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
5d302c92-7ebe-40eb-9772-fcae3973b9b9	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
9e18e41f-0518-45b9-97ae-8277ee4a5770	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
04c1e342-51a5-442d-a2be-143fc33184ea	username	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
9c18cfab-9579-4df2-b2a2-6e64fa212191	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
015cf778-28a4-4209-b4af-f967904b7b90	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
a4a03f93-280e-43c9-8e6c-681311259d16	website	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
72492548-47a3-43f6-a03f-c929975830e8	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
aee96896-525f-43b3-ac20-68296ba2f298	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
db988fe0-1db4-431d-81d9-88bce55a88aa	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
fded2a61-c523-4d4f-a07f-3d12a4ea6638	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	d609acfd-2a2d-4cc3-beae-7e57214766b0
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	email	openid-connect	oidc-usermodel-attribute-mapper	\N	9a8bde13-3625-43a2-abe3-ff373fdaa243
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	email verified	openid-connect	oidc-usermodel-property-mapper	\N	9a8bde13-3625-43a2-abe3-ff373fdaa243
ad2be305-be01-4484-ad2b-1532907b169d	address	openid-connect	oidc-address-mapper	\N	3d914493-56ec-4fd5-bb7a-6523e38cdda0
3e09061a-39d1-4ea4-90e5-9ae6795e868e	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	fe1dc014-a6b3-4b37-a8da-b259dd1cd057
776840c9-59a0-4717-91dd-716835c27fac	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	fe1dc014-a6b3-4b37-a8da-b259dd1cd057
28f7528e-0fd0-4235-aebf-407f614c8843	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	b19b596e-bd20-46c4-aa1f-20e02d39f33b
48d92bb4-b305-43cf-881e-a561d0462a75	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	b19b596e-bd20-46c4-aa1f-20e02d39f33b
c3222f73-2246-4ec3-b9de-41e1827e2430	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	b19b596e-bd20-46c4-aa1f-20e02d39f33b
6fe37ce9-a5e4-4be6-b77c-7d0e81777f4d	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	d7d9d4dc-37a9-49ad-b7ec-fc91628aa7ef
5dedd0f6-889e-4e08-b6d1-babf9ace5487	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	004c569d-07a9-401b-b218-5cec626a0c28
f5b69749-3424-4c2c-af04-72560f9e1e4e	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	004c569d-07a9-401b-b218-5cec626a0c28
2af038ef-91c9-4ee6-9829-8953c127e048	acr loa level	openid-connect	oidc-acr-mapper	\N	92e20777-eba7-4271-919d-af54d5b790dc
4eee4472-5d91-43f2-a63e-e3d4f55f3ee1	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	e23685c8-91dd-48ed-8d80-4ee85e2d62ef
0e53679a-8f7f-4878-8330-b285d3cf2ad3	sub	openid-connect	oidc-sub-mapper	\N	e23685c8-91dd-48ed-8d80-4ee85e2d62ef
e455ba66-fb66-4de9-ab61-711ad9be0b73	organization	openid-connect	oidc-organization-membership-mapper	\N	772a7d75-ddc7-403b-8d0e-f17662bbda42
f55cf60c-da24-4faf-91d4-59ca18add677	locale	openid-connect	oidc-usermodel-attribute-mapper	0e9e2341-b009-4953-808d-0492c93c809d	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	true	introspection.token.claim
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	true	userinfo.token.claim
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	locale	user.attribute
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	true	id.token.claim
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	true	access.token.claim
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	locale	claim.name
87aa5a8e-7a8e-4b26-afff-baf243f6ee74	String	jsonType.label
6c0b6b23-952d-4cf9-a439-3afeed9961bc	false	single
6c0b6b23-952d-4cf9-a439-3afeed9961bc	Basic	attribute.nameformat
6c0b6b23-952d-4cf9-a439-3afeed9961bc	Role	attribute.name
0cf87bc9-721a-4b0b-abfa-ca6c342a11ed	true	introspection.token.claim
0cf87bc9-721a-4b0b-abfa-ca6c342a11ed	true	userinfo.token.claim
0cf87bc9-721a-4b0b-abfa-ca6c342a11ed	true	id.token.claim
0cf87bc9-721a-4b0b-abfa-ca6c342a11ed	true	access.token.claim
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	true	introspection.token.claim
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	true	userinfo.token.claim
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	locale	user.attribute
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	true	id.token.claim
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	true	access.token.claim
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	locale	claim.name
17ca8d3f-f7da-4895-86d2-24b084b5c6d3	String	jsonType.label
570cd066-db79-4ef7-85fa-fc55568a93bb	true	introspection.token.claim
570cd066-db79-4ef7-85fa-fc55568a93bb	true	userinfo.token.claim
570cd066-db79-4ef7-85fa-fc55568a93bb	firstName	user.attribute
570cd066-db79-4ef7-85fa-fc55568a93bb	true	id.token.claim
570cd066-db79-4ef7-85fa-fc55568a93bb	true	access.token.claim
570cd066-db79-4ef7-85fa-fc55568a93bb	given_name	claim.name
570cd066-db79-4ef7-85fa-fc55568a93bb	String	jsonType.label
80911a14-9522-4e54-8868-7eb83be74f9b	true	introspection.token.claim
80911a14-9522-4e54-8868-7eb83be74f9b	true	userinfo.token.claim
80911a14-9522-4e54-8868-7eb83be74f9b	birthdate	user.attribute
80911a14-9522-4e54-8868-7eb83be74f9b	true	id.token.claim
80911a14-9522-4e54-8868-7eb83be74f9b	true	access.token.claim
80911a14-9522-4e54-8868-7eb83be74f9b	birthdate	claim.name
80911a14-9522-4e54-8868-7eb83be74f9b	String	jsonType.label
866871c6-5961-4b4f-a143-6b93ce5110fc	true	introspection.token.claim
866871c6-5961-4b4f-a143-6b93ce5110fc	true	userinfo.token.claim
866871c6-5961-4b4f-a143-6b93ce5110fc	website	user.attribute
866871c6-5961-4b4f-a143-6b93ce5110fc	true	id.token.claim
866871c6-5961-4b4f-a143-6b93ce5110fc	true	access.token.claim
866871c6-5961-4b4f-a143-6b93ce5110fc	website	claim.name
866871c6-5961-4b4f-a143-6b93ce5110fc	String	jsonType.label
87297115-78c9-4037-b43c-19430bb3f9e9	true	introspection.token.claim
87297115-78c9-4037-b43c-19430bb3f9e9	true	userinfo.token.claim
87297115-78c9-4037-b43c-19430bb3f9e9	middleName	user.attribute
87297115-78c9-4037-b43c-19430bb3f9e9	true	id.token.claim
87297115-78c9-4037-b43c-19430bb3f9e9	true	access.token.claim
87297115-78c9-4037-b43c-19430bb3f9e9	middle_name	claim.name
87297115-78c9-4037-b43c-19430bb3f9e9	String	jsonType.label
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	true	introspection.token.claim
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	true	userinfo.token.claim
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	picture	user.attribute
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	true	id.token.claim
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	true	access.token.claim
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	picture	claim.name
9d9497ac-9c54-41c1-ac7c-7a4dbba5bd38	String	jsonType.label
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	true	introspection.token.claim
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	true	userinfo.token.claim
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	zoneinfo	user.attribute
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	true	id.token.claim
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	true	access.token.claim
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	zoneinfo	claim.name
a3a6cccb-1b33-4974-8a4c-6ec1ea5c0f45	String	jsonType.label
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	true	introspection.token.claim
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	true	userinfo.token.claim
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	updatedAt	user.attribute
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	true	id.token.claim
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	true	access.token.claim
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	updated_at	claim.name
b37c2ee7-8ace-4c92-a1e2-b0c84208c14d	long	jsonType.label
d0489e3b-183a-49cf-9f23-f58b11c085d0	true	introspection.token.claim
d0489e3b-183a-49cf-9f23-f58b11c085d0	true	userinfo.token.claim
d0489e3b-183a-49cf-9f23-f58b11c085d0	gender	user.attribute
d0489e3b-183a-49cf-9f23-f58b11c085d0	true	id.token.claim
d0489e3b-183a-49cf-9f23-f58b11c085d0	true	access.token.claim
d0489e3b-183a-49cf-9f23-f58b11c085d0	gender	claim.name
d0489e3b-183a-49cf-9f23-f58b11c085d0	String	jsonType.label
defe79cf-a23f-4f23-9f4c-8822b807be55	true	introspection.token.claim
defe79cf-a23f-4f23-9f4c-8822b807be55	true	userinfo.token.claim
defe79cf-a23f-4f23-9f4c-8822b807be55	nickname	user.attribute
defe79cf-a23f-4f23-9f4c-8822b807be55	true	id.token.claim
defe79cf-a23f-4f23-9f4c-8822b807be55	true	access.token.claim
defe79cf-a23f-4f23-9f4c-8822b807be55	nickname	claim.name
defe79cf-a23f-4f23-9f4c-8822b807be55	String	jsonType.label
ef20f109-f113-4a5a-9123-562c197d3c2a	true	introspection.token.claim
ef20f109-f113-4a5a-9123-562c197d3c2a	true	userinfo.token.claim
ef20f109-f113-4a5a-9123-562c197d3c2a	profile	user.attribute
ef20f109-f113-4a5a-9123-562c197d3c2a	true	id.token.claim
ef20f109-f113-4a5a-9123-562c197d3c2a	true	access.token.claim
ef20f109-f113-4a5a-9123-562c197d3c2a	profile	claim.name
ef20f109-f113-4a5a-9123-562c197d3c2a	String	jsonType.label
ef3dc7be-3a95-43e7-ac80-ef1be1974575	true	introspection.token.claim
ef3dc7be-3a95-43e7-ac80-ef1be1974575	true	userinfo.token.claim
ef3dc7be-3a95-43e7-ac80-ef1be1974575	lastName	user.attribute
ef3dc7be-3a95-43e7-ac80-ef1be1974575	true	id.token.claim
ef3dc7be-3a95-43e7-ac80-ef1be1974575	true	access.token.claim
ef3dc7be-3a95-43e7-ac80-ef1be1974575	family_name	claim.name
ef3dc7be-3a95-43e7-ac80-ef1be1974575	String	jsonType.label
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	true	introspection.token.claim
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	true	userinfo.token.claim
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	username	user.attribute
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	true	id.token.claim
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	true	access.token.claim
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	preferred_username	claim.name
f75a49f1-d9a4-48d6-8f8a-909255bf98fb	String	jsonType.label
62eb67f1-ad3d-40f1-9ef0-796eb607065d	true	introspection.token.claim
62eb67f1-ad3d-40f1-9ef0-796eb607065d	true	userinfo.token.claim
62eb67f1-ad3d-40f1-9ef0-796eb607065d	emailVerified	user.attribute
62eb67f1-ad3d-40f1-9ef0-796eb607065d	true	id.token.claim
62eb67f1-ad3d-40f1-9ef0-796eb607065d	true	access.token.claim
62eb67f1-ad3d-40f1-9ef0-796eb607065d	email_verified	claim.name
62eb67f1-ad3d-40f1-9ef0-796eb607065d	boolean	jsonType.label
d4af1aa2-346f-42bc-9120-46ee8a943618	true	introspection.token.claim
d4af1aa2-346f-42bc-9120-46ee8a943618	true	userinfo.token.claim
d4af1aa2-346f-42bc-9120-46ee8a943618	email	user.attribute
d4af1aa2-346f-42bc-9120-46ee8a943618	true	id.token.claim
d4af1aa2-346f-42bc-9120-46ee8a943618	true	access.token.claim
d4af1aa2-346f-42bc-9120-46ee8a943618	email	claim.name
d4af1aa2-346f-42bc-9120-46ee8a943618	String	jsonType.label
c0132bc9-b69d-44ad-9a05-4800c1ba1635	formatted	user.attribute.formatted
c0132bc9-b69d-44ad-9a05-4800c1ba1635	country	user.attribute.country
c0132bc9-b69d-44ad-9a05-4800c1ba1635	true	introspection.token.claim
c0132bc9-b69d-44ad-9a05-4800c1ba1635	postal_code	user.attribute.postal_code
c0132bc9-b69d-44ad-9a05-4800c1ba1635	true	userinfo.token.claim
c0132bc9-b69d-44ad-9a05-4800c1ba1635	street	user.attribute.street
c0132bc9-b69d-44ad-9a05-4800c1ba1635	true	id.token.claim
c0132bc9-b69d-44ad-9a05-4800c1ba1635	region	user.attribute.region
c0132bc9-b69d-44ad-9a05-4800c1ba1635	true	access.token.claim
c0132bc9-b69d-44ad-9a05-4800c1ba1635	locality	user.attribute.locality
286b0895-4fc2-456c-b1ed-4a0bc5836e90	true	introspection.token.claim
286b0895-4fc2-456c-b1ed-4a0bc5836e90	true	userinfo.token.claim
286b0895-4fc2-456c-b1ed-4a0bc5836e90	phoneNumberVerified	user.attribute
286b0895-4fc2-456c-b1ed-4a0bc5836e90	true	id.token.claim
286b0895-4fc2-456c-b1ed-4a0bc5836e90	true	access.token.claim
286b0895-4fc2-456c-b1ed-4a0bc5836e90	phone_number_verified	claim.name
286b0895-4fc2-456c-b1ed-4a0bc5836e90	boolean	jsonType.label
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	true	introspection.token.claim
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	true	userinfo.token.claim
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	phoneNumber	user.attribute
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	true	id.token.claim
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	true	access.token.claim
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	phone_number	claim.name
48af96fd-34fa-4cfc-9638-0ef1d8eddb58	String	jsonType.label
36b41ef8-842e-4511-9d75-8ee25428381f	true	introspection.token.claim
36b41ef8-842e-4511-9d75-8ee25428381f	true	multivalued
36b41ef8-842e-4511-9d75-8ee25428381f	foo	user.attribute
36b41ef8-842e-4511-9d75-8ee25428381f	true	access.token.claim
36b41ef8-842e-4511-9d75-8ee25428381f	realm_access.roles	claim.name
36b41ef8-842e-4511-9d75-8ee25428381f	String	jsonType.label
65598705-bb75-4545-b690-2db60d2242a7	true	introspection.token.claim
65598705-bb75-4545-b690-2db60d2242a7	true	multivalued
65598705-bb75-4545-b690-2db60d2242a7	foo	user.attribute
65598705-bb75-4545-b690-2db60d2242a7	true	access.token.claim
65598705-bb75-4545-b690-2db60d2242a7	resource_access.${client_id}.roles	claim.name
65598705-bb75-4545-b690-2db60d2242a7	String	jsonType.label
8fef025a-b26e-4357-9b24-77a2ec3581e2	true	introspection.token.claim
8fef025a-b26e-4357-9b24-77a2ec3581e2	true	access.token.claim
dbf92fb8-c2d8-468a-914d-614a943e9e65	true	introspection.token.claim
dbf92fb8-c2d8-468a-914d-614a943e9e65	true	access.token.claim
68df7a8c-8b07-4cd6-8594-3459654787d2	true	introspection.token.claim
68df7a8c-8b07-4cd6-8594-3459654787d2	true	multivalued
68df7a8c-8b07-4cd6-8594-3459654787d2	foo	user.attribute
68df7a8c-8b07-4cd6-8594-3459654787d2	true	id.token.claim
68df7a8c-8b07-4cd6-8594-3459654787d2	true	access.token.claim
68df7a8c-8b07-4cd6-8594-3459654787d2	groups	claim.name
68df7a8c-8b07-4cd6-8594-3459654787d2	String	jsonType.label
6abc9acd-959b-401f-89f5-bfef6aaf6315	true	introspection.token.claim
6abc9acd-959b-401f-89f5-bfef6aaf6315	true	userinfo.token.claim
6abc9acd-959b-401f-89f5-bfef6aaf6315	username	user.attribute
6abc9acd-959b-401f-89f5-bfef6aaf6315	true	id.token.claim
6abc9acd-959b-401f-89f5-bfef6aaf6315	true	access.token.claim
6abc9acd-959b-401f-89f5-bfef6aaf6315	upn	claim.name
6abc9acd-959b-401f-89f5-bfef6aaf6315	String	jsonType.label
746c9654-e45f-4bb1-a149-4a2e5978feea	true	introspection.token.claim
746c9654-e45f-4bb1-a149-4a2e5978feea	true	id.token.claim
746c9654-e45f-4bb1-a149-4a2e5978feea	true	access.token.claim
1f44619f-9152-42e0-ab81-7a5d6754f742	true	introspection.token.claim
1f44619f-9152-42e0-ab81-7a5d6754f742	true	access.token.claim
388df0a1-1f3c-4a7c-99a5-e9027fb22283	AUTH_TIME	user.session.note
388df0a1-1f3c-4a7c-99a5-e9027fb22283	true	introspection.token.claim
388df0a1-1f3c-4a7c-99a5-e9027fb22283	true	id.token.claim
388df0a1-1f3c-4a7c-99a5-e9027fb22283	true	access.token.claim
388df0a1-1f3c-4a7c-99a5-e9027fb22283	auth_time	claim.name
388df0a1-1f3c-4a7c-99a5-e9027fb22283	long	jsonType.label
ca103b0a-c320-4f5a-b83a-12dd65c6f738	true	introspection.token.claim
ca103b0a-c320-4f5a-b83a-12dd65c6f738	true	multivalued
ca103b0a-c320-4f5a-b83a-12dd65c6f738	true	id.token.claim
ca103b0a-c320-4f5a-b83a-12dd65c6f738	true	access.token.claim
ca103b0a-c320-4f5a-b83a-12dd65c6f738	organization	claim.name
ca103b0a-c320-4f5a-b83a-12dd65c6f738	String	jsonType.label
3fe6a42a-5a63-42e1-9922-a74ecb568f47	false	single
3fe6a42a-5a63-42e1-9922-a74ecb568f47	Basic	attribute.nameformat
3fe6a42a-5a63-42e1-9922-a74ecb568f47	Role	attribute.name
015cf778-28a4-4209-b4af-f967904b7b90	true	introspection.token.claim
015cf778-28a4-4209-b4af-f967904b7b90	true	userinfo.token.claim
015cf778-28a4-4209-b4af-f967904b7b90	picture	user.attribute
015cf778-28a4-4209-b4af-f967904b7b90	true	id.token.claim
015cf778-28a4-4209-b4af-f967904b7b90	true	access.token.claim
015cf778-28a4-4209-b4af-f967904b7b90	picture	claim.name
015cf778-28a4-4209-b4af-f967904b7b90	String	jsonType.label
04c1e342-51a5-442d-a2be-143fc33184ea	true	introspection.token.claim
04c1e342-51a5-442d-a2be-143fc33184ea	true	userinfo.token.claim
04c1e342-51a5-442d-a2be-143fc33184ea	username	user.attribute
04c1e342-51a5-442d-a2be-143fc33184ea	true	id.token.claim
04c1e342-51a5-442d-a2be-143fc33184ea	true	access.token.claim
04c1e342-51a5-442d-a2be-143fc33184ea	preferred_username	claim.name
04c1e342-51a5-442d-a2be-143fc33184ea	String	jsonType.label
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	true	introspection.token.claim
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	true	userinfo.token.claim
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	firstName	user.attribute
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	true	id.token.claim
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	true	access.token.claim
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	given_name	claim.name
05b19586-2d66-4f78-a8a9-f8cbdc0cbc87	String	jsonType.label
1d0dde3b-f089-4f10-9709-3963d84e5f14	true	introspection.token.claim
1d0dde3b-f089-4f10-9709-3963d84e5f14	true	userinfo.token.claim
1d0dde3b-f089-4f10-9709-3963d84e5f14	true	id.token.claim
1d0dde3b-f089-4f10-9709-3963d84e5f14	true	access.token.claim
5d302c92-7ebe-40eb-9772-fcae3973b9b9	true	introspection.token.claim
5d302c92-7ebe-40eb-9772-fcae3973b9b9	true	userinfo.token.claim
5d302c92-7ebe-40eb-9772-fcae3973b9b9	middleName	user.attribute
5d302c92-7ebe-40eb-9772-fcae3973b9b9	true	id.token.claim
5d302c92-7ebe-40eb-9772-fcae3973b9b9	true	access.token.claim
5d302c92-7ebe-40eb-9772-fcae3973b9b9	middle_name	claim.name
5d302c92-7ebe-40eb-9772-fcae3973b9b9	String	jsonType.label
72492548-47a3-43f6-a03f-c929975830e8	true	introspection.token.claim
72492548-47a3-43f6-a03f-c929975830e8	true	userinfo.token.claim
72492548-47a3-43f6-a03f-c929975830e8	gender	user.attribute
72492548-47a3-43f6-a03f-c929975830e8	true	id.token.claim
72492548-47a3-43f6-a03f-c929975830e8	true	access.token.claim
72492548-47a3-43f6-a03f-c929975830e8	gender	claim.name
72492548-47a3-43f6-a03f-c929975830e8	String	jsonType.label
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	true	introspection.token.claim
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	true	userinfo.token.claim
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	locale	user.attribute
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	true	id.token.claim
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	true	access.token.claim
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	locale	claim.name
98a181ff-4ec1-4493-bddb-487bb4c6a6f4	String	jsonType.label
9c18cfab-9579-4df2-b2a2-6e64fa212191	true	introspection.token.claim
9c18cfab-9579-4df2-b2a2-6e64fa212191	true	userinfo.token.claim
9c18cfab-9579-4df2-b2a2-6e64fa212191	profile	user.attribute
9c18cfab-9579-4df2-b2a2-6e64fa212191	true	id.token.claim
9c18cfab-9579-4df2-b2a2-6e64fa212191	true	access.token.claim
9c18cfab-9579-4df2-b2a2-6e64fa212191	profile	claim.name
9c18cfab-9579-4df2-b2a2-6e64fa212191	String	jsonType.label
9e18e41f-0518-45b9-97ae-8277ee4a5770	true	introspection.token.claim
9e18e41f-0518-45b9-97ae-8277ee4a5770	true	userinfo.token.claim
9e18e41f-0518-45b9-97ae-8277ee4a5770	nickname	user.attribute
9e18e41f-0518-45b9-97ae-8277ee4a5770	true	id.token.claim
9e18e41f-0518-45b9-97ae-8277ee4a5770	true	access.token.claim
9e18e41f-0518-45b9-97ae-8277ee4a5770	nickname	claim.name
9e18e41f-0518-45b9-97ae-8277ee4a5770	String	jsonType.label
a4a03f93-280e-43c9-8e6c-681311259d16	true	introspection.token.claim
a4a03f93-280e-43c9-8e6c-681311259d16	true	userinfo.token.claim
a4a03f93-280e-43c9-8e6c-681311259d16	website	user.attribute
a4a03f93-280e-43c9-8e6c-681311259d16	true	id.token.claim
a4a03f93-280e-43c9-8e6c-681311259d16	true	access.token.claim
a4a03f93-280e-43c9-8e6c-681311259d16	website	claim.name
a4a03f93-280e-43c9-8e6c-681311259d16	String	jsonType.label
aee96896-525f-43b3-ac20-68296ba2f298	true	introspection.token.claim
aee96896-525f-43b3-ac20-68296ba2f298	true	userinfo.token.claim
aee96896-525f-43b3-ac20-68296ba2f298	birthdate	user.attribute
aee96896-525f-43b3-ac20-68296ba2f298	true	id.token.claim
aee96896-525f-43b3-ac20-68296ba2f298	true	access.token.claim
aee96896-525f-43b3-ac20-68296ba2f298	birthdate	claim.name
aee96896-525f-43b3-ac20-68296ba2f298	String	jsonType.label
db988fe0-1db4-431d-81d9-88bce55a88aa	true	introspection.token.claim
db988fe0-1db4-431d-81d9-88bce55a88aa	true	userinfo.token.claim
db988fe0-1db4-431d-81d9-88bce55a88aa	zoneinfo	user.attribute
db988fe0-1db4-431d-81d9-88bce55a88aa	true	id.token.claim
db988fe0-1db4-431d-81d9-88bce55a88aa	true	access.token.claim
db988fe0-1db4-431d-81d9-88bce55a88aa	zoneinfo	claim.name
db988fe0-1db4-431d-81d9-88bce55a88aa	String	jsonType.label
f04baad6-d3b0-44e3-8bec-853cd4525bff	true	introspection.token.claim
f04baad6-d3b0-44e3-8bec-853cd4525bff	true	userinfo.token.claim
f04baad6-d3b0-44e3-8bec-853cd4525bff	lastName	user.attribute
f04baad6-d3b0-44e3-8bec-853cd4525bff	true	id.token.claim
f04baad6-d3b0-44e3-8bec-853cd4525bff	true	access.token.claim
f04baad6-d3b0-44e3-8bec-853cd4525bff	family_name	claim.name
f04baad6-d3b0-44e3-8bec-853cd4525bff	String	jsonType.label
fded2a61-c523-4d4f-a07f-3d12a4ea6638	true	introspection.token.claim
fded2a61-c523-4d4f-a07f-3d12a4ea6638	true	userinfo.token.claim
fded2a61-c523-4d4f-a07f-3d12a4ea6638	updatedAt	user.attribute
fded2a61-c523-4d4f-a07f-3d12a4ea6638	true	id.token.claim
fded2a61-c523-4d4f-a07f-3d12a4ea6638	true	access.token.claim
fded2a61-c523-4d4f-a07f-3d12a4ea6638	updated_at	claim.name
fded2a61-c523-4d4f-a07f-3d12a4ea6638	long	jsonType.label
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	true	introspection.token.claim
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	true	userinfo.token.claim
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	emailVerified	user.attribute
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	true	id.token.claim
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	true	access.token.claim
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	email_verified	claim.name
30529d4b-dc2e-44aa-9b1c-1df555dad3bb	boolean	jsonType.label
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	true	introspection.token.claim
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	true	userinfo.token.claim
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	email	user.attribute
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	true	id.token.claim
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	true	access.token.claim
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	email	claim.name
7b2618a6-e4dc-4c9c-ab59-1bc94bc3e3dc	String	jsonType.label
ad2be305-be01-4484-ad2b-1532907b169d	formatted	user.attribute.formatted
ad2be305-be01-4484-ad2b-1532907b169d	country	user.attribute.country
ad2be305-be01-4484-ad2b-1532907b169d	true	introspection.token.claim
ad2be305-be01-4484-ad2b-1532907b169d	postal_code	user.attribute.postal_code
ad2be305-be01-4484-ad2b-1532907b169d	true	userinfo.token.claim
ad2be305-be01-4484-ad2b-1532907b169d	street	user.attribute.street
ad2be305-be01-4484-ad2b-1532907b169d	true	id.token.claim
ad2be305-be01-4484-ad2b-1532907b169d	region	user.attribute.region
ad2be305-be01-4484-ad2b-1532907b169d	true	access.token.claim
ad2be305-be01-4484-ad2b-1532907b169d	locality	user.attribute.locality
3e09061a-39d1-4ea4-90e5-9ae6795e868e	true	introspection.token.claim
3e09061a-39d1-4ea4-90e5-9ae6795e868e	true	userinfo.token.claim
3e09061a-39d1-4ea4-90e5-9ae6795e868e	phoneNumber	user.attribute
3e09061a-39d1-4ea4-90e5-9ae6795e868e	true	id.token.claim
3e09061a-39d1-4ea4-90e5-9ae6795e868e	true	access.token.claim
3e09061a-39d1-4ea4-90e5-9ae6795e868e	phone_number	claim.name
3e09061a-39d1-4ea4-90e5-9ae6795e868e	String	jsonType.label
776840c9-59a0-4717-91dd-716835c27fac	true	introspection.token.claim
776840c9-59a0-4717-91dd-716835c27fac	true	userinfo.token.claim
776840c9-59a0-4717-91dd-716835c27fac	phoneNumberVerified	user.attribute
776840c9-59a0-4717-91dd-716835c27fac	true	id.token.claim
776840c9-59a0-4717-91dd-716835c27fac	true	access.token.claim
776840c9-59a0-4717-91dd-716835c27fac	phone_number_verified	claim.name
776840c9-59a0-4717-91dd-716835c27fac	boolean	jsonType.label
28f7528e-0fd0-4235-aebf-407f614c8843	true	introspection.token.claim
28f7528e-0fd0-4235-aebf-407f614c8843	true	multivalued
28f7528e-0fd0-4235-aebf-407f614c8843	foo	user.attribute
28f7528e-0fd0-4235-aebf-407f614c8843	true	access.token.claim
28f7528e-0fd0-4235-aebf-407f614c8843	realm_access.roles	claim.name
28f7528e-0fd0-4235-aebf-407f614c8843	String	jsonType.label
48d92bb4-b305-43cf-881e-a561d0462a75	true	introspection.token.claim
48d92bb4-b305-43cf-881e-a561d0462a75	true	multivalued
48d92bb4-b305-43cf-881e-a561d0462a75	foo	user.attribute
48d92bb4-b305-43cf-881e-a561d0462a75	true	access.token.claim
48d92bb4-b305-43cf-881e-a561d0462a75	resource_access.${client_id}.roles	claim.name
48d92bb4-b305-43cf-881e-a561d0462a75	String	jsonType.label
c3222f73-2246-4ec3-b9de-41e1827e2430	true	introspection.token.claim
c3222f73-2246-4ec3-b9de-41e1827e2430	true	access.token.claim
6fe37ce9-a5e4-4be6-b77c-7d0e81777f4d	true	introspection.token.claim
6fe37ce9-a5e4-4be6-b77c-7d0e81777f4d	true	access.token.claim
5dedd0f6-889e-4e08-b6d1-babf9ace5487	true	introspection.token.claim
5dedd0f6-889e-4e08-b6d1-babf9ace5487	true	userinfo.token.claim
5dedd0f6-889e-4e08-b6d1-babf9ace5487	username	user.attribute
5dedd0f6-889e-4e08-b6d1-babf9ace5487	true	id.token.claim
5dedd0f6-889e-4e08-b6d1-babf9ace5487	true	access.token.claim
5dedd0f6-889e-4e08-b6d1-babf9ace5487	upn	claim.name
5dedd0f6-889e-4e08-b6d1-babf9ace5487	String	jsonType.label
f5b69749-3424-4c2c-af04-72560f9e1e4e	true	introspection.token.claim
f5b69749-3424-4c2c-af04-72560f9e1e4e	true	multivalued
f5b69749-3424-4c2c-af04-72560f9e1e4e	foo	user.attribute
f5b69749-3424-4c2c-af04-72560f9e1e4e	true	id.token.claim
f5b69749-3424-4c2c-af04-72560f9e1e4e	true	access.token.claim
f5b69749-3424-4c2c-af04-72560f9e1e4e	groups	claim.name
f5b69749-3424-4c2c-af04-72560f9e1e4e	String	jsonType.label
2af038ef-91c9-4ee6-9829-8953c127e048	true	introspection.token.claim
2af038ef-91c9-4ee6-9829-8953c127e048	true	id.token.claim
2af038ef-91c9-4ee6-9829-8953c127e048	true	access.token.claim
0e53679a-8f7f-4878-8330-b285d3cf2ad3	true	introspection.token.claim
0e53679a-8f7f-4878-8330-b285d3cf2ad3	true	access.token.claim
4eee4472-5d91-43f2-a63e-e3d4f55f3ee1	AUTH_TIME	user.session.note
4eee4472-5d91-43f2-a63e-e3d4f55f3ee1	true	introspection.token.claim
4eee4472-5d91-43f2-a63e-e3d4f55f3ee1	true	id.token.claim
4eee4472-5d91-43f2-a63e-e3d4f55f3ee1	true	access.token.claim
4eee4472-5d91-43f2-a63e-e3d4f55f3ee1	auth_time	claim.name
4eee4472-5d91-43f2-a63e-e3d4f55f3ee1	long	jsonType.label
e455ba66-fb66-4de9-ab61-711ad9be0b73	true	introspection.token.claim
e455ba66-fb66-4de9-ab61-711ad9be0b73	true	multivalued
e455ba66-fb66-4de9-ab61-711ad9be0b73	true	id.token.claim
e455ba66-fb66-4de9-ab61-711ad9be0b73	true	access.token.claim
e455ba66-fb66-4de9-ab61-711ad9be0b73	organization	claim.name
e455ba66-fb66-4de9-ab61-711ad9be0b73	String	jsonType.label
f55cf60c-da24-4faf-91d4-59ca18add677	true	introspection.token.claim
f55cf60c-da24-4faf-91d4-59ca18add677	true	userinfo.token.claim
f55cf60c-da24-4faf-91d4-59ca18add677	locale	user.attribute
f55cf60c-da24-4faf-91d4-59ca18add677	true	id.token.claim
f55cf60c-da24-4faf-91d4-59ca18add677	true	access.token.claim
f55cf60c-da24-4faf-91d4-59ca18add677	locale	claim.name
f55cf60c-da24-4faf-91d4-59ca18add677	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
106128c4-abe4-410c-82af-b8d094c1c313	60	300	300	\N	\N	\N	t	f	0	\N	FdoTestbed	0	\N	f	f	f	f	NONE	1800	36000	f	f	f17d49e1-1994-4c2a-9130-3e0353fabc06	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	24170321-3ffd-49b1-96e7-8f9e7292df0f	58b06581-f5e1-411a-b621-ae5517361576	22de8b5b-2c75-45c3-8963-23154813cc53	ce3effbe-bd6b-480f-875c-54b35437e920	428a0777-6b4e-42e7-b116-c5e5393d3c91	2592000	f	900	t	f	5955cd49-a492-48ef-a681-bddacefcd0b5	0	f	0	0	b831367a-109f-4dc3-95c2-e2c2bd8a4ba6
8fb72edd-3595-407b-9597-900a93b73829	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	ffb4d769-de1f-4d8a-a202-8ae8c60485e0	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	887797d9-b772-43fe-83e0-3fbc9e17a100	7cecc287-334b-4c89-974a-901b8dba445b	e4d9cd76-1b2e-4a11-95fb-c3cfeb35290a	d1155f76-b750-49c1-90ae-7e79bef97329	61fbec52-eb6c-4bb6-ac14-10f8d6c2d77c	2592000	f	900	t	f	68b7499c-7a18-4af3-88c0-7bbfad1a66d1	0	f	0	0	52491b27-eaac-40f8-84a4-9398ba7fbd95
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	8fb72edd-3595-407b-9597-900a93b73829	
_browser_header.xContentTypeOptions	8fb72edd-3595-407b-9597-900a93b73829	nosniff
_browser_header.referrerPolicy	8fb72edd-3595-407b-9597-900a93b73829	no-referrer
_browser_header.xRobotsTag	8fb72edd-3595-407b-9597-900a93b73829	none
_browser_header.xFrameOptions	8fb72edd-3595-407b-9597-900a93b73829	SAMEORIGIN
_browser_header.contentSecurityPolicy	8fb72edd-3595-407b-9597-900a93b73829	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	8fb72edd-3595-407b-9597-900a93b73829	1; mode=block
_browser_header.strictTransportSecurity	8fb72edd-3595-407b-9597-900a93b73829	max-age=31536000; includeSubDomains
bruteForceProtected	8fb72edd-3595-407b-9597-900a93b73829	false
permanentLockout	8fb72edd-3595-407b-9597-900a93b73829	false
maxTemporaryLockouts	8fb72edd-3595-407b-9597-900a93b73829	0
maxFailureWaitSeconds	8fb72edd-3595-407b-9597-900a93b73829	900
minimumQuickLoginWaitSeconds	8fb72edd-3595-407b-9597-900a93b73829	60
waitIncrementSeconds	8fb72edd-3595-407b-9597-900a93b73829	60
quickLoginCheckMilliSeconds	8fb72edd-3595-407b-9597-900a93b73829	1000
maxDeltaTimeSeconds	8fb72edd-3595-407b-9597-900a93b73829	43200
failureFactor	8fb72edd-3595-407b-9597-900a93b73829	30
realmReusableOtpCode	8fb72edd-3595-407b-9597-900a93b73829	false
firstBrokerLoginFlowId	8fb72edd-3595-407b-9597-900a93b73829	ff774387-2d49-45e5-8176-3a3eff4932ba
displayName	8fb72edd-3595-407b-9597-900a93b73829	Keycloak
displayNameHtml	8fb72edd-3595-407b-9597-900a93b73829	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	8fb72edd-3595-407b-9597-900a93b73829	RS256
offlineSessionMaxLifespanEnabled	8fb72edd-3595-407b-9597-900a93b73829	false
offlineSessionMaxLifespan	8fb72edd-3595-407b-9597-900a93b73829	5184000
bruteForceProtected	106128c4-abe4-410c-82af-b8d094c1c313	false
permanentLockout	106128c4-abe4-410c-82af-b8d094c1c313	false
maxTemporaryLockouts	106128c4-abe4-410c-82af-b8d094c1c313	0
maxFailureWaitSeconds	106128c4-abe4-410c-82af-b8d094c1c313	900
minimumQuickLoginWaitSeconds	106128c4-abe4-410c-82af-b8d094c1c313	60
waitIncrementSeconds	106128c4-abe4-410c-82af-b8d094c1c313	60
quickLoginCheckMilliSeconds	106128c4-abe4-410c-82af-b8d094c1c313	1000
maxDeltaTimeSeconds	106128c4-abe4-410c-82af-b8d094c1c313	43200
failureFactor	106128c4-abe4-410c-82af-b8d094c1c313	30
realmReusableOtpCode	106128c4-abe4-410c-82af-b8d094c1c313	false
defaultSignatureAlgorithm	106128c4-abe4-410c-82af-b8d094c1c313	RS256
offlineSessionMaxLifespanEnabled	106128c4-abe4-410c-82af-b8d094c1c313	false
offlineSessionMaxLifespan	106128c4-abe4-410c-82af-b8d094c1c313	5184000
actionTokenGeneratedByAdminLifespan	106128c4-abe4-410c-82af-b8d094c1c313	43200
actionTokenGeneratedByUserLifespan	106128c4-abe4-410c-82af-b8d094c1c313	300
oauth2DeviceCodeLifespan	106128c4-abe4-410c-82af-b8d094c1c313	600
oauth2DevicePollingInterval	106128c4-abe4-410c-82af-b8d094c1c313	5
webAuthnPolicyRpEntityName	106128c4-abe4-410c-82af-b8d094c1c313	keycloak
webAuthnPolicySignatureAlgorithms	106128c4-abe4-410c-82af-b8d094c1c313	ES256,RS256
webAuthnPolicyRpId	106128c4-abe4-410c-82af-b8d094c1c313	
webAuthnPolicyAttestationConveyancePreference	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyAuthenticatorAttachment	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyRequireResidentKey	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyUserVerificationRequirement	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyCreateTimeout	106128c4-abe4-410c-82af-b8d094c1c313	0
webAuthnPolicyAvoidSameAuthenticatorRegister	106128c4-abe4-410c-82af-b8d094c1c313	false
webAuthnPolicyRpEntityNamePasswordless	106128c4-abe4-410c-82af-b8d094c1c313	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	106128c4-abe4-410c-82af-b8d094c1c313	ES256,RS256
webAuthnPolicyRpIdPasswordless	106128c4-abe4-410c-82af-b8d094c1c313	
webAuthnPolicyAttestationConveyancePreferencePasswordless	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyRequireResidentKeyPasswordless	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	106128c4-abe4-410c-82af-b8d094c1c313	not specified
webAuthnPolicyCreateTimeoutPasswordless	106128c4-abe4-410c-82af-b8d094c1c313	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	106128c4-abe4-410c-82af-b8d094c1c313	false
cibaBackchannelTokenDeliveryMode	106128c4-abe4-410c-82af-b8d094c1c313	poll
cibaExpiresIn	106128c4-abe4-410c-82af-b8d094c1c313	120
cibaInterval	106128c4-abe4-410c-82af-b8d094c1c313	5
cibaAuthRequestedUserHint	106128c4-abe4-410c-82af-b8d094c1c313	login_hint
parRequestUriLifespan	106128c4-abe4-410c-82af-b8d094c1c313	60
firstBrokerLoginFlowId	106128c4-abe4-410c-82af-b8d094c1c313	3dd3d088-0751-4b91-bfb8-bb8abf19b8d2
acr.loa.map	106128c4-abe4-410c-82af-b8d094c1c313	{}
frontendUrl	106128c4-abe4-410c-82af-b8d094c1c313	
displayName	106128c4-abe4-410c-82af-b8d094c1c313	
displayNameHtml	106128c4-abe4-410c-82af-b8d094c1c313	
client-policies.profiles	106128c4-abe4-410c-82af-b8d094c1c313	{"profiles":[]}
client-policies.policies	106128c4-abe4-410c-82af-b8d094c1c313	{"policies":[]}
organizationsEnabled	106128c4-abe4-410c-82af-b8d094c1c313	false
clientSessionIdleTimeout	106128c4-abe4-410c-82af-b8d094c1c313	0
clientSessionMaxLifespan	106128c4-abe4-410c-82af-b8d094c1c313	0
clientOfflineSessionIdleTimeout	106128c4-abe4-410c-82af-b8d094c1c313	0
clientOfflineSessionMaxLifespan	106128c4-abe4-410c-82af-b8d094c1c313	0
_browser_header.contentSecurityPolicyReportOnly	106128c4-abe4-410c-82af-b8d094c1c313	
_browser_header.xContentTypeOptions	106128c4-abe4-410c-82af-b8d094c1c313	nosniff
_browser_header.referrerPolicy	106128c4-abe4-410c-82af-b8d094c1c313	no-referrer
_browser_header.xRobotsTag	106128c4-abe4-410c-82af-b8d094c1c313	none
_browser_header.xFrameOptions	106128c4-abe4-410c-82af-b8d094c1c313	SAMEORIGIN
_browser_header.contentSecurityPolicy	106128c4-abe4-410c-82af-b8d094c1c313	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	106128c4-abe4-410c-82af-b8d094c1c313	1; mode=block
_browser_header.strictTransportSecurity	106128c4-abe4-410c-82af-b8d094c1c313	max-age=31536000; includeSubDomains
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
8fb72edd-3595-407b-9597-900a93b73829	jboss-logging
106128c4-abe4-410c-82af-b8d094c1c313	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	8fb72edd-3595-407b-9597-900a93b73829
password	password	t	t	106128c4-abe4-410c-82af-b8d094c1c313
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.redirect_uris (client_id, value) FROM stdin;
e58cdd2a-c86d-4477-9182-8d2448818975	/realms/master/account/*
a1009637-d602-4178-8531-be4cd5eddbdd	/realms/master/account/*
83e64015-a218-4024-8318-fb3ffe674c30	/admin/master/console/*
22a1d428-ec7b-4f91-a222-06c55a128831	/realms/FdoTestbed/account/*
1ef61626-bfd6-4c61-ba3c-e93a688b330f	/realms/FdoTestbed/account/*
0e9e2341-b009-4953-808d-0492c93c809d	/admin/FdoTestbed/console/*
5ad6ff62-dcfe-479b-b323-cd560f4a7799	*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
d0cd61c7-e2f4-44ae-a253-cb9c301fb3dc	VERIFY_EMAIL	Verify Email	8fb72edd-3595-407b-9597-900a93b73829	t	f	VERIFY_EMAIL	50
d1560891-82ca-41d6-b968-954f0a5fd639	UPDATE_PROFILE	Update Profile	8fb72edd-3595-407b-9597-900a93b73829	t	f	UPDATE_PROFILE	40
d0091342-344b-4d47-ad6f-6bce0831d0e1	CONFIGURE_TOTP	Configure OTP	8fb72edd-3595-407b-9597-900a93b73829	t	f	CONFIGURE_TOTP	10
890099a9-e9ba-425e-adc7-26af1e4574fe	UPDATE_PASSWORD	Update Password	8fb72edd-3595-407b-9597-900a93b73829	t	f	UPDATE_PASSWORD	30
81478fc3-83c1-40f5-a60a-07ac01fcc377	TERMS_AND_CONDITIONS	Terms and Conditions	8fb72edd-3595-407b-9597-900a93b73829	f	f	TERMS_AND_CONDITIONS	20
ac7b25dd-c140-4e18-abab-60668a7ed75c	delete_account	Delete Account	8fb72edd-3595-407b-9597-900a93b73829	f	f	delete_account	60
5bb4b411-be20-4a1b-9fa7-6bb0ca70d7d6	delete_credential	Delete Credential	8fb72edd-3595-407b-9597-900a93b73829	t	f	delete_credential	100
5b0caaa1-5d2d-4b0e-baec-0d78c63afcd1	update_user_locale	Update User Locale	8fb72edd-3595-407b-9597-900a93b73829	t	f	update_user_locale	1000
4b36814e-db94-438c-85d4-fba49b30a837	webauthn-register	Webauthn Register	8fb72edd-3595-407b-9597-900a93b73829	t	f	webauthn-register	70
624a5854-d463-4a87-a6ac-bdf346c034fd	webauthn-register-passwordless	Webauthn Register Passwordless	8fb72edd-3595-407b-9597-900a93b73829	t	f	webauthn-register-passwordless	80
d60a0d07-72bf-4989-ab8e-3467f68db736	VERIFY_PROFILE	Verify Profile	8fb72edd-3595-407b-9597-900a93b73829	t	f	VERIFY_PROFILE	90
92a9f6c5-eec7-442a-ba8d-45ddecaaf5c9	VERIFY_EMAIL	Verify Email	106128c4-abe4-410c-82af-b8d094c1c313	t	f	VERIFY_EMAIL	50
ef3e2bca-dfb7-488c-ac95-e6bc8d08e672	UPDATE_PROFILE	Update Profile	106128c4-abe4-410c-82af-b8d094c1c313	t	f	UPDATE_PROFILE	40
8ebc73b2-938b-4453-b091-5895d1e67cdd	CONFIGURE_TOTP	Configure OTP	106128c4-abe4-410c-82af-b8d094c1c313	t	f	CONFIGURE_TOTP	10
d5f600d3-21b4-4b5a-b4a6-81e25f7aebb8	UPDATE_PASSWORD	Update Password	106128c4-abe4-410c-82af-b8d094c1c313	t	f	UPDATE_PASSWORD	30
9fdc2306-5554-4007-926f-3aad05ffaca0	TERMS_AND_CONDITIONS	Terms and Conditions	106128c4-abe4-410c-82af-b8d094c1c313	f	f	TERMS_AND_CONDITIONS	20
adefbf4f-9693-4cc8-b788-28176d147ce2	delete_account	Delete Account	106128c4-abe4-410c-82af-b8d094c1c313	f	f	delete_account	60
e578a18f-9855-4396-9275-4577e7ffa286	delete_credential	Delete Credential	106128c4-abe4-410c-82af-b8d094c1c313	t	f	delete_credential	100
28ba6dcf-371e-4a9d-b2e8-9ff0e108bfed	update_user_locale	Update User Locale	106128c4-abe4-410c-82af-b8d094c1c313	t	f	update_user_locale	1000
30e6b4ae-bc2d-48d8-8ff4-f3a4949c938e	webauthn-register	Webauthn Register	106128c4-abe4-410c-82af-b8d094c1c313	t	f	webauthn-register	70
bfae0993-3f3a-452c-b995-e24fe4667aaf	webauthn-register-passwordless	Webauthn Register Passwordless	106128c4-abe4-410c-82af-b8d094c1c313	t	f	webauthn-register-passwordless	80
e5930e6c-5bf4-4a3e-a2cd-6472be93b734	VERIFY_PROFILE	Verify Profile	106128c4-abe4-410c-82af-b8d094c1c313	t	f	VERIFY_PROFILE	90
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
a1009637-d602-4178-8531-be4cd5eddbdd	49fd5038-149c-472e-9173-04d7e26946be
a1009637-d602-4178-8531-be4cd5eddbdd	2dc4af82-d9cd-4e18-b7af-9e7e361a0d95
1ef61626-bfd6-4c61-ba3c-e93a688b330f	a0c8c17f-a296-431a-b495-fe5c02276198
1ef61626-bfd6-4c61-ba3c-e93a688b330f	11c7e4a5-08ce-4856-801e-182b107e63cc
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
is_temporary_admin	true	d75c86b5-9c77-45cb-b277-232022f9a826	cd96803d-4af6-4322-86b3-ca8c0e29601f	\N	\N	\N
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
d75c86b5-9c77-45cb-b277-232022f9a826	\N	5bcc6c36-1f6a-4114-b087-5700bd51df42	f	t	\N	\N	\N	8fb72edd-3595-407b-9597-900a93b73829	admin	1729462325464	\N	0
e0d3593f-af63-4fd0-bd55-850919e319b9	user@example.com	user@example.com	t	t	\N	User	Example	106128c4-abe4-410c-82af-b8d094c1c313	user	1729463551421	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
52491b27-eaac-40f8-84a4-9398ba7fbd95	d75c86b5-9c77-45cb-b277-232022f9a826
206480c7-6f60-4253-93eb-f45856d65148	d75c86b5-9c77-45cb-b277-232022f9a826
b831367a-109f-4dc3-95c2-e2c2bd8a4ba6	e0d3593f-af63-4fd0-bd55-850919e319b9
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: username
--

COPY public.web_origins (client_id, value) FROM stdin;
83e64015-a218-4024-8318-fb3ffe674c30	+
0e9e2341-b009-4953-808d-0492c93c809d	+
5ad6ff62-dcfe-479b-b323-cd560f4a7799	*
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: username
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: username
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

