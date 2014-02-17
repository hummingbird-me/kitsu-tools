--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: anime; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE anime (
    id integer NOT NULL,
    title character varying(255),
    alt_title character varying(255),
    slug character varying(255),
    age_rating character varying(255),
    episode_count integer,
    episode_length integer,
    synopsis text,
    youtube_video_id character varying(255),
    mal_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cover_image_file_name character varying(255),
    cover_image_content_type character varying(255),
    cover_image_file_size integer,
    cover_image_updated_at timestamp without time zone,
    bayesian_average double precision DEFAULT 0,
    user_count integer,
    thetvdb_series_id character varying(255),
    thetvdb_season_id character varying(255),
    english_canonical boolean DEFAULT false,
    age_rating_guide character varying(255),
    show_type character varying(255),
    started_airing_date date,
    finished_airing_date date,
    rating_frequencies hstore DEFAULT ''::hstore NOT NULL,
    poster_image_file_name character varying(255),
    poster_image_content_type character varying(255),
    poster_image_file_size integer,
    poster_image_updated_at timestamp without time zone,
    cover_image_top_offset integer,
    ann_id integer,
    started_airing_date_known boolean DEFAULT true
);


--
-- Name: anime_franchises; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE anime_franchises (
    anime_id integer,
    franchise_id integer
);


--
-- Name: anime_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE anime_genres (
    anime_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: anime_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE anime_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE anime_id_seq OWNED BY anime.id;


--
-- Name: anime_producers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE anime_producers (
    anime_id integer NOT NULL,
    producer_id integer NOT NULL
);


--
-- Name: beta_invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE beta_invites (
    id integer NOT NULL,
    email character varying(255),
    token character varying(255),
    invited boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    subscribed boolean DEFAULT true,
    encrypted_email character varying(255)
);


--
-- Name: beta_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE beta_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: beta_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE beta_invites_id_seq OWNED BY beta_invites.id;


--
-- Name: castings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE castings (
    id integer NOT NULL,
    anime_id integer,
    person_id integer,
    character_id integer,
    role character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    voice_actor boolean,
    featured boolean,
    "order" integer,
    language character varying(255)
);


--
-- Name: castings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE castings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: castings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE castings_id_seq OWNED BY castings.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE characters (
    id integer NOT NULL,
    name character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mal_id integer,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE characters_id_seq OWNED BY characters.id;


--
-- Name: episodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE episodes (
    id integer NOT NULL,
    anime_id integer,
    number integer,
    title character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    season_number integer
);


--
-- Name: episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE episodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE episodes_id_seq OWNED BY episodes.id;


--
-- Name: favorite_genres_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favorite_genres_users (
    genre_id integer,
    user_id integer
);


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favorites (
    id integer NOT NULL,
    user_id integer,
    item_id integer,
    item_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favorites_id_seq OWNED BY favorites.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE follows (
    id integer NOT NULL,
    followed_id integer,
    follower_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE follows_id_seq OWNED BY follows.id;


--
-- Name: forem_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: forem_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_categories_id_seq OWNED BY forem_categories.id;


--
-- Name: forem_forums; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_forums (
    id integer NOT NULL,
    name character varying(255),
    description text,
    category_id integer,
    views_count integer DEFAULT 0,
    slug character varying(255),
    sort_order integer
);


--
-- Name: forem_forums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_forums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_forums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_forums_id_seq OWNED BY forem_forums.id;


--
-- Name: forem_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_groups (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: forem_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_groups_id_seq OWNED BY forem_groups.id;


--
-- Name: forem_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_memberships (
    id integer NOT NULL,
    group_id integer,
    member_id integer
);


--
-- Name: forem_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_memberships_id_seq OWNED BY forem_memberships.id;


--
-- Name: forem_moderator_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_moderator_groups (
    id integer NOT NULL,
    forum_id integer,
    group_id integer
);


--
-- Name: forem_moderator_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_moderator_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_moderator_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_moderator_groups_id_seq OWNED BY forem_moderator_groups.id;


--
-- Name: forem_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_posts (
    id integer NOT NULL,
    topic_id integer,
    text text,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    reply_to_id integer,
    state character varying(255) DEFAULT 'approved'::character varying,
    notified boolean DEFAULT false,
    formatted_html text
);


--
-- Name: forem_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_posts_id_seq OWNED BY forem_posts.id;


--
-- Name: forem_subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_subscriptions (
    id integer NOT NULL,
    subscriber_id integer,
    topic_id integer
);


--
-- Name: forem_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_subscriptions_id_seq OWNED BY forem_subscriptions.id;


--
-- Name: forem_topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_topics (
    id integer NOT NULL,
    forum_id integer,
    user_id integer,
    subject character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    pinned boolean DEFAULT false,
    hidden boolean DEFAULT false,
    last_post_at timestamp without time zone,
    state character varying(255) DEFAULT 'approved'::character varying,
    views_count integer DEFAULT 0,
    slug character varying(255)
);


--
-- Name: forem_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_topics_id_seq OWNED BY forem_topics.id;


--
-- Name: forem_views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forem_views (
    id integer NOT NULL,
    user_id integer,
    viewable_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    count integer DEFAULT 0,
    viewable_type character varying(255),
    current_viewed_at timestamp without time zone,
    past_viewed_at timestamp without time zone
);


--
-- Name: forem_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forem_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forem_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forem_views_id_seq OWNED BY forem_views.id;


--
-- Name: franchises; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE franchises (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    english_title character varying(255),
    romaji_title character varying(255)
);


--
-- Name: franchises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE franchises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: franchises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE franchises_id_seq OWNED BY franchises.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(40),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: gallery_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gallery_images (
    id integer NOT NULL,
    anime_id integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone
);


--
-- Name: gallery_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gallery_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gallery_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gallery_images_id_seq OWNED BY gallery_images.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genres (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text
);


--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE genres_id_seq OWNED BY genres.id;


--
-- Name: genres_manga; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genres_manga (
    manga_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: manga; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE manga (
    id integer NOT NULL,
    romaji_title character varying(255),
    slug character varying(255),
    english_title character varying(255),
    synopsis text,
    poster_image_file_name character varying(255),
    poster_image_content_type character varying(255),
    poster_image_file_size integer,
    poster_image_updated_at timestamp without time zone,
    cover_image_file_name character varying(255),
    cover_image_content_type character varying(255),
    cover_image_file_size integer,
    cover_image_updated_at timestamp without time zone,
    start_date date,
    end_date date,
    serialization character varying(255),
    mal_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying(255),
    cover_image_top_offset integer DEFAULT 0,
    volume_count integer,
    chapter_count integer
);


--
-- Name: manga_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE manga_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manga_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE manga_id_seq OWNED BY manga.id;


--
-- Name: not_interesteds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE not_interesteds (
    id integer NOT NULL,
    user_id integer,
    media_id integer,
    media_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: not_interesteds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE not_interesteds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: not_interesteds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE not_interesteds_id_seq OWNED BY not_interesteds.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer,
    source_id integer,
    source_type character varying(255),
    data hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notification_type character varying(255),
    seen boolean DEFAULT false
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mal_id integer,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: producers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE producers (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: producers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE producers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: producers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE producers_id_seq OWNED BY producers.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quotes (
    id integer NOT NULL,
    anime_id integer,
    content text,
    character_name character varying(255),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    positive_votes integer DEFAULT 0 NOT NULL
);


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quotes_id_seq OWNED BY quotes.id;


--
-- Name: rails_admin_histories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rails_admin_histories (
    id integer NOT NULL,
    message text,
    username character varying(255),
    item integer,
    "table" character varying(255),
    month integer,
    year integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rails_admin_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rails_admin_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rails_admin_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rails_admin_histories_id_seq OWNED BY rails_admin_histories.id;


--
-- Name: recommendations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommendations (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recommendations hstore
);


--
-- Name: recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommendations_id_seq OWNED BY recommendations.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reviews (
    id integer NOT NULL,
    user_id integer,
    anime_id integer,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rating integer,
    source character varying(255),
    rating_story integer,
    rating_animation integer,
    rating_sound integer,
    rating_character integer,
    rating_enjoyment integer,
    summary character varying(255),
    wilson_score double precision DEFAULT 0.0,
    positive_votes integer DEFAULT 0,
    total_votes integer DEFAULT 0
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reviews_id_seq OWNED BY reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stories (
    id integer NOT NULL,
    user_id integer,
    data hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    story_type character varying(255),
    target_id integer,
    target_type character varying(255),
    watchlist_id integer,
    adult boolean DEFAULT false
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stories_id_seq OWNED BY stories.id;


--
-- Name: substories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE substories (
    id integer NOT NULL,
    user_id integer,
    substory_type character varying(255),
    story_id integer,
    target_id integer,
    target_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data hstore
);


--
-- Name: substories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE substories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: substories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE substories_id_seq OWNED BY substories.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255),
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recommendations_up_to_date boolean,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    facebook_id character varying(255),
    bio text,
    sfw_filter boolean DEFAULT true,
    star_rating boolean DEFAULT false,
    mal_username character varying(255),
    life_spent_on_anime integer DEFAULT 0 NOT NULL,
    about text,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    forem_admin boolean DEFAULT false,
    forem_state character varying(255) DEFAULT 'approved'::character varying,
    forem_auto_subscribe boolean DEFAULT false,
    cover_image_file_name character varying(255),
    cover_image_content_type character varying(255),
    cover_image_file_size integer,
    cover_image_updated_at timestamp without time zone,
    english_anime_titles boolean DEFAULT true,
    title_language_preference character varying(255) DEFAULT 'canonical'::character varying,
    followers_count_hack integer DEFAULT 0,
    following_count integer DEFAULT 0,
    neon_alley_integration boolean DEFAULT false,
    ninja_banned boolean DEFAULT false,
    last_library_update timestamp without time zone,
    last_recommendations_update timestamp without time zone,
    authentication_token character varying(255),
    avatar_processing boolean,
    subscribed_to_newsletter boolean DEFAULT true,
    mal_import_in_progress boolean
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    target_id integer NOT NULL,
    target_type character varying(255) NOT NULL,
    user_id integer NOT NULL,
    positive boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: watchlists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE watchlists (
    id integer NOT NULL,
    user_id integer,
    anime_id integer,
    status character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    episodes_watched integer DEFAULT 0 NOT NULL,
    rating numeric(2,1),
    last_watched timestamp without time zone,
    imported boolean,
    private boolean DEFAULT false,
    notes text,
    rewatch_count integer DEFAULT 0 NOT NULL,
    rewatching boolean DEFAULT false NOT NULL
);


--
-- Name: watchlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE watchlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: watchlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE watchlists_id_seq OWNED BY watchlists.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY anime ALTER COLUMN id SET DEFAULT nextval('anime_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY beta_invites ALTER COLUMN id SET DEFAULT nextval('beta_invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY castings ALTER COLUMN id SET DEFAULT nextval('castings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY characters ALTER COLUMN id SET DEFAULT nextval('characters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY episodes ALTER COLUMN id SET DEFAULT nextval('episodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorites ALTER COLUMN id SET DEFAULT nextval('favorites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_categories ALTER COLUMN id SET DEFAULT nextval('forem_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_forums ALTER COLUMN id SET DEFAULT nextval('forem_forums_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_groups ALTER COLUMN id SET DEFAULT nextval('forem_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_memberships ALTER COLUMN id SET DEFAULT nextval('forem_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_moderator_groups ALTER COLUMN id SET DEFAULT nextval('forem_moderator_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_posts ALTER COLUMN id SET DEFAULT nextval('forem_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_subscriptions ALTER COLUMN id SET DEFAULT nextval('forem_subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_topics ALTER COLUMN id SET DEFAULT nextval('forem_topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forem_views ALTER COLUMN id SET DEFAULT nextval('forem_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY franchises ALTER COLUMN id SET DEFAULT nextval('franchises_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gallery_images ALTER COLUMN id SET DEFAULT nextval('gallery_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY genres ALTER COLUMN id SET DEFAULT nextval('genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY manga ALTER COLUMN id SET DEFAULT nextval('manga_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY not_interesteds ALTER COLUMN id SET DEFAULT nextval('not_interesteds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY producers ALTER COLUMN id SET DEFAULT nextval('producers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes ALTER COLUMN id SET DEFAULT nextval('quotes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rails_admin_histories ALTER COLUMN id SET DEFAULT nextval('rails_admin_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recommendations ALTER COLUMN id SET DEFAULT nextval('recommendations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews ALTER COLUMN id SET DEFAULT nextval('reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories ALTER COLUMN id SET DEFAULT nextval('stories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY substories ALTER COLUMN id SET DEFAULT nextval('substories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY watchlists ALTER COLUMN id SET DEFAULT nextval('watchlists_id_seq'::regclass);


--
-- Name: anime_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY anime
    ADD CONSTRAINT anime_pkey PRIMARY KEY (id);


--
-- Name: beta_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY beta_invites
    ADD CONSTRAINT beta_invites_pkey PRIMARY KEY (id);


--
-- Name: castings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY castings
    ADD CONSTRAINT castings_pkey PRIMARY KEY (id);


--
-- Name: characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (id);


--
-- Name: favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: forem_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_categories
    ADD CONSTRAINT forem_categories_pkey PRIMARY KEY (id);


--
-- Name: forem_forums_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_forums
    ADD CONSTRAINT forem_forums_pkey PRIMARY KEY (id);


--
-- Name: forem_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_groups
    ADD CONSTRAINT forem_groups_pkey PRIMARY KEY (id);


--
-- Name: forem_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_memberships
    ADD CONSTRAINT forem_memberships_pkey PRIMARY KEY (id);


--
-- Name: forem_moderator_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_moderator_groups
    ADD CONSTRAINT forem_moderator_groups_pkey PRIMARY KEY (id);


--
-- Name: forem_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_posts
    ADD CONSTRAINT forem_posts_pkey PRIMARY KEY (id);


--
-- Name: forem_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_subscriptions
    ADD CONSTRAINT forem_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: forem_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_topics
    ADD CONSTRAINT forem_topics_pkey PRIMARY KEY (id);


--
-- Name: forem_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forem_views
    ADD CONSTRAINT forem_views_pkey PRIMARY KEY (id);


--
-- Name: franchises_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY franchises
    ADD CONSTRAINT franchises_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: gallery_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gallery_images
    ADD CONSTRAINT gallery_images_pkey PRIMARY KEY (id);


--
-- Name: genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: manga_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY manga
    ADD CONSTRAINT manga_pkey PRIMARY KEY (id);


--
-- Name: not_interesteds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY not_interesteds
    ADD CONSTRAINT not_interesteds_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: producers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (id);


--
-- Name: quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: rails_admin_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rails_admin_histories
    ADD CONSTRAINT rails_admin_histories_pkey PRIMARY KEY (id);


--
-- Name: recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);


--
-- Name: reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: substories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY substories
    ADD CONSTRAINT substories_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: watchlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY watchlists
    ADD CONSTRAINT watchlists_pkey PRIMARY KEY (id);


--
-- Name: anime_search_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX anime_search_index ON anime USING gin ((((COALESCE((title)::text, ''::text) || ' '::text) || COALESCE((alt_title)::text, ''::text))) gin_trgm_ops);


--
-- Name: anime_simple_search_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX anime_simple_search_index ON anime USING gin (((to_tsvector('simple'::regconfig, COALESCE((title)::text, ''::text)) || to_tsvector('simple'::regconfig, COALESCE((alt_title)::text, ''::text)))));


--
-- Name: character_mal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX character_mal_id ON characters USING btree (mal_id);


--
-- Name: index_anime_genres_on_anime_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_anime_genres_on_anime_id ON anime_genres USING btree (anime_id);


--
-- Name: index_anime_genres_on_genre_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_anime_genres_on_genre_id ON anime_genres USING btree (genre_id);


--
-- Name: index_anime_on_mal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_anime_on_mal_id ON anime USING btree (mal_id);


--
-- Name: index_anime_on_wilson_ci; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_anime_on_wilson_ci ON anime USING btree (bayesian_average DESC);


--
-- Name: index_castings_on_anime_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_castings_on_anime_id ON castings USING btree (anime_id);


--
-- Name: index_castings_on_character_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_castings_on_character_id ON castings USING btree (character_id);


--
-- Name: index_castings_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_castings_on_person_id ON castings USING btree (person_id);


--
-- Name: index_characters_on_mal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_characters_on_mal_id ON characters USING btree (mal_id);


--
-- Name: index_episodes_on_anime_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_episodes_on_anime_id ON episodes USING btree (anime_id);


--
-- Name: index_favorite_genres_users_on_genre_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_favorite_genres_users_on_genre_id_and_user_id ON favorite_genres_users USING btree (genre_id, user_id);


--
-- Name: index_favorites_on_item_id_and_item_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_item_id_and_item_type ON favorites USING btree (item_id, item_type);


--
-- Name: index_favorites_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_user_id ON favorites USING btree (user_id);


--
-- Name: index_favorites_on_user_id_and_item_id_and_item_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_favorites_on_user_id_and_item_id_and_item_type ON favorites USING btree (user_id, item_id, item_type);


--
-- Name: index_follows_on_followed_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_follows_on_followed_id ON follows USING btree (follower_id);


--
-- Name: index_follows_on_followed_id_and_follower_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_follows_on_followed_id_and_follower_id ON follows USING btree (followed_id, follower_id);


--
-- Name: index_follows_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_follows_on_user_id ON follows USING btree (followed_id);


--
-- Name: index_forem_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_forem_categories_on_slug ON forem_categories USING btree (slug);


--
-- Name: index_forem_forums_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_forem_forums_on_slug ON forem_forums USING btree (slug);


--
-- Name: index_forem_groups_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_groups_on_name ON forem_groups USING btree (name);


--
-- Name: index_forem_memberships_on_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_memberships_on_group_id ON forem_memberships USING btree (group_id);


--
-- Name: index_forem_moderator_groups_on_forum_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_moderator_groups_on_forum_id ON forem_moderator_groups USING btree (forum_id);


--
-- Name: index_forem_posts_on_reply_to_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_posts_on_reply_to_id ON forem_posts USING btree (reply_to_id);


--
-- Name: index_forem_posts_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_posts_on_state ON forem_posts USING btree (state);


--
-- Name: index_forem_posts_on_topic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_posts_on_topic_id ON forem_posts USING btree (topic_id);


--
-- Name: index_forem_posts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_posts_on_user_id ON forem_posts USING btree (user_id);


--
-- Name: index_forem_topics_on_forum_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_topics_on_forum_id ON forem_topics USING btree (forum_id);


--
-- Name: index_forem_topics_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_forem_topics_on_slug ON forem_topics USING btree (slug);


--
-- Name: index_forem_topics_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_topics_on_state ON forem_topics USING btree (state);


--
-- Name: index_forem_topics_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_topics_on_user_id ON forem_topics USING btree (user_id);


--
-- Name: index_forem_views_on_topic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_views_on_topic_id ON forem_views USING btree (viewable_id);


--
-- Name: index_forem_views_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_views_on_updated_at ON forem_views USING btree (updated_at);


--
-- Name: index_forem_views_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forem_views_on_user_id ON forem_views USING btree (user_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_gallery_images_on_anime_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gallery_images_on_anime_id ON gallery_images USING btree (anime_id);


--
-- Name: index_genres_manga_on_genre_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_genres_manga_on_genre_id ON genres_manga USING btree (genre_id);


--
-- Name: index_genres_manga_on_manga_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_genres_manga_on_manga_id ON genres_manga USING btree (manga_id);


--
-- Name: index_not_interesteds_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_not_interesteds_on_user_id ON not_interesteds USING btree (user_id);


--
-- Name: index_notifications_on_source_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_source_id ON notifications USING btree (source_id);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_user_id ON notifications USING btree (user_id);


--
-- Name: index_people_on_mal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_people_on_mal_id ON people USING btree (mal_id);


--
-- Name: index_stories_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stories_on_user_id ON stories USING btree (user_id);


--
-- Name: index_substories_on_story_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_substories_on_story_id ON substories USING btree (story_id);


--
-- Name: index_substories_on_target_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_substories_on_target_id ON substories USING btree (target_id);


--
-- Name: index_substories_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_substories_on_user_id ON substories USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_facebook_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_facebook_id ON users USING btree (facebook_id);


--
-- Name: index_users_on_lower_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_lower_name_index ON users USING btree (lower((name)::text));


--
-- Name: index_votes_on_target_id_and_target_type_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_votes_on_target_id_and_target_type_and_user_id ON votes USING btree (target_id, target_type, user_id);


--
-- Name: index_watchlists_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_watchlists_on_user_id ON watchlists USING btree (user_id);


--
-- Name: index_watchlists_on_user_id_and_anime_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_watchlists_on_user_id_and_anime_id ON watchlists USING btree (user_id, anime_id);


--
-- Name: index_watchlists_on_user_id_and_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_watchlists_on_user_id_and_status ON watchlists USING btree (user_id, status);


--
-- Name: manga_fuzzy_search_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX manga_fuzzy_search_index ON manga USING gin ((((COALESCE((romaji_title)::text, ''::text) || ' '::text) || COALESCE((english_title)::text, ''::text))) gin_trgm_ops);


--
-- Name: manga_simple_search_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX manga_simple_search_index ON manga USING gin (((to_tsvector('simple'::regconfig, COALESCE((romaji_title)::text, ''::text)) || to_tsvector('simple'::regconfig, COALESCE((english_title)::text, ''::text)))));


--
-- Name: person_mal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX person_mal_id ON people USING btree (mal_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130129153309');

INSERT INTO schema_migrations (version) VALUES ('20130129160306');

INSERT INTO schema_migrations (version) VALUES ('20130129160719');

INSERT INTO schema_migrations (version) VALUES ('20130129160916');

INSERT INTO schema_migrations (version) VALUES ('20130129200416');

INSERT INTO schema_migrations (version) VALUES ('20130130114735');

INSERT INTO schema_migrations (version) VALUES ('20130130124651');

INSERT INTO schema_migrations (version) VALUES ('20130130211236');

INSERT INTO schema_migrations (version) VALUES ('20130130221825');

INSERT INTO schema_migrations (version) VALUES ('20130130221914');

INSERT INTO schema_migrations (version) VALUES ('20130131113813');

INSERT INTO schema_migrations (version) VALUES ('20130131124309');

INSERT INTO schema_migrations (version) VALUES ('20130131124541');

INSERT INTO schema_migrations (version) VALUES ('20130131125336');

INSERT INTO schema_migrations (version) VALUES ('20130131211433');

INSERT INTO schema_migrations (version) VALUES ('20130201115714');

INSERT INTO schema_migrations (version) VALUES ('20130201130558');

INSERT INTO schema_migrations (version) VALUES ('20130201201120');

INSERT INTO schema_migrations (version) VALUES ('20130201203506');

INSERT INTO schema_migrations (version) VALUES ('20130201211530');

INSERT INTO schema_migrations (version) VALUES ('20130201213650');

INSERT INTO schema_migrations (version) VALUES ('20130201213910');

INSERT INTO schema_migrations (version) VALUES ('20130202124409');

INSERT INTO schema_migrations (version) VALUES ('20130202183927');

INSERT INTO schema_migrations (version) VALUES ('20130202184202');

INSERT INTO schema_migrations (version) VALUES ('20130203043003');

INSERT INTO schema_migrations (version) VALUES ('20130203044353');

INSERT INTO schema_migrations (version) VALUES ('20130203123847');

INSERT INTO schema_migrations (version) VALUES ('20130204104825');

INSERT INTO schema_migrations (version) VALUES ('20130205102136');

INSERT INTO schema_migrations (version) VALUES ('20130205120013');

INSERT INTO schema_migrations (version) VALUES ('20130205203649');

INSERT INTO schema_migrations (version) VALUES ('20130206033352');

INSERT INTO schema_migrations (version) VALUES ('20130206033532');

INSERT INTO schema_migrations (version) VALUES ('20130206041446');

INSERT INTO schema_migrations (version) VALUES ('20130206044249');

INSERT INTO schema_migrations (version) VALUES ('20130206044250');

INSERT INTO schema_migrations (version) VALUES ('20130206044251');

INSERT INTO schema_migrations (version) VALUES ('20130206044252');

INSERT INTO schema_migrations (version) VALUES ('20130206044253');

INSERT INTO schema_migrations (version) VALUES ('20130206044254');

INSERT INTO schema_migrations (version) VALUES ('20130206044255');

INSERT INTO schema_migrations (version) VALUES ('20130206190932');

INSERT INTO schema_migrations (version) VALUES ('20130206190933');

INSERT INTO schema_migrations (version) VALUES ('20130206190934');

INSERT INTO schema_migrations (version) VALUES ('20130206190935');

INSERT INTO schema_migrations (version) VALUES ('20130206190936');

INSERT INTO schema_migrations (version) VALUES ('20130206190937');

INSERT INTO schema_migrations (version) VALUES ('20130206190938');

INSERT INTO schema_migrations (version) VALUES ('20130206190939');

INSERT INTO schema_migrations (version) VALUES ('20130206190940');

INSERT INTO schema_migrations (version) VALUES ('20130206190941');

INSERT INTO schema_migrations (version) VALUES ('20130206190942');

INSERT INTO schema_migrations (version) VALUES ('20130206190943');

INSERT INTO schema_migrations (version) VALUES ('20130206190944');

INSERT INTO schema_migrations (version) VALUES ('20130206190945');

INSERT INTO schema_migrations (version) VALUES ('20130206190946');

INSERT INTO schema_migrations (version) VALUES ('20130206190947');

INSERT INTO schema_migrations (version) VALUES ('20130206190948');

INSERT INTO schema_migrations (version) VALUES ('20130206190949');

INSERT INTO schema_migrations (version) VALUES ('20130206190950');

INSERT INTO schema_migrations (version) VALUES ('20130206190951');

INSERT INTO schema_migrations (version) VALUES ('20130206190952');

INSERT INTO schema_migrations (version) VALUES ('20130206190953');

INSERT INTO schema_migrations (version) VALUES ('20130206190954');

INSERT INTO schema_migrations (version) VALUES ('20130206190955');

INSERT INTO schema_migrations (version) VALUES ('20130206190956');

INSERT INTO schema_migrations (version) VALUES ('20130206190957');

INSERT INTO schema_migrations (version) VALUES ('20130206190958');

INSERT INTO schema_migrations (version) VALUES ('20130206190959');

INSERT INTO schema_migrations (version) VALUES ('20130206190960');

INSERT INTO schema_migrations (version) VALUES ('20130207115242');

INSERT INTO schema_migrations (version) VALUES ('20130207120507');

INSERT INTO schema_migrations (version) VALUES ('20130207182552');

INSERT INTO schema_migrations (version) VALUES ('20130207204819');

INSERT INTO schema_migrations (version) VALUES ('20130209015709');

INSERT INTO schema_migrations (version) VALUES ('20130209021809');

INSERT INTO schema_migrations (version) VALUES ('20130209060246');

INSERT INTO schema_migrations (version) VALUES ('20130210015622');

INSERT INTO schema_migrations (version) VALUES ('20130210060436');

INSERT INTO schema_migrations (version) VALUES ('20130210174247');

INSERT INTO schema_migrations (version) VALUES ('20130210194104');

INSERT INTO schema_migrations (version) VALUES ('20130211143138');

INSERT INTO schema_migrations (version) VALUES ('20130211160513');

INSERT INTO schema_migrations (version) VALUES ('20130211160533');

INSERT INTO schema_migrations (version) VALUES ('20130211201937');

INSERT INTO schema_migrations (version) VALUES ('20130212194720');

INSERT INTO schema_migrations (version) VALUES ('20130212195213');

INSERT INTO schema_migrations (version) VALUES ('20130212195307');

INSERT INTO schema_migrations (version) VALUES ('20130212201230');

INSERT INTO schema_migrations (version) VALUES ('20130212201303');

INSERT INTO schema_migrations (version) VALUES ('20130212203850');

INSERT INTO schema_migrations (version) VALUES ('20130212210145');

INSERT INTO schema_migrations (version) VALUES ('20130214052459');

INSERT INTO schema_migrations (version) VALUES ('20130214054215');

INSERT INTO schema_migrations (version) VALUES ('20130214055141');

INSERT INTO schema_migrations (version) VALUES ('20130214212717');

INSERT INTO schema_migrations (version) VALUES ('20130214232033');

INSERT INTO schema_migrations (version) VALUES ('20130214232840');

INSERT INTO schema_migrations (version) VALUES ('20130217152544');

INSERT INTO schema_migrations (version) VALUES ('20130220183447');

INSERT INTO schema_migrations (version) VALUES ('20130221172813');

INSERT INTO schema_migrations (version) VALUES ('20130225171241');

INSERT INTO schema_migrations (version) VALUES ('20130227044350');

INSERT INTO schema_migrations (version) VALUES ('20130227142433');

INSERT INTO schema_migrations (version) VALUES ('20130227185901');

INSERT INTO schema_migrations (version) VALUES ('20130227192935');

INSERT INTO schema_migrations (version) VALUES ('20130227194841');

INSERT INTO schema_migrations (version) VALUES ('20130227195132');

INSERT INTO schema_migrations (version) VALUES ('20130301170219');

INSERT INTO schema_migrations (version) VALUES ('20130301182309');

INSERT INTO schema_migrations (version) VALUES ('20130302062704');

INSERT INTO schema_migrations (version) VALUES ('20130302080631');

INSERT INTO schema_migrations (version) VALUES ('20130302100724');

INSERT INTO schema_migrations (version) VALUES ('20130302101826');

INSERT INTO schema_migrations (version) VALUES ('20130302112208');

INSERT INTO schema_migrations (version) VALUES ('20130302185243');

INSERT INTO schema_migrations (version) VALUES ('20130303072149');

INSERT INTO schema_migrations (version) VALUES ('20130304223624');

INSERT INTO schema_migrations (version) VALUES ('20130306184127');

INSERT INTO schema_migrations (version) VALUES ('20130306211425');

INSERT INTO schema_migrations (version) VALUES ('20130306211738');

INSERT INTO schema_migrations (version) VALUES ('20130309181216');

INSERT INTO schema_migrations (version) VALUES ('20130309181217');

INSERT INTO schema_migrations (version) VALUES ('20130309181218');

INSERT INTO schema_migrations (version) VALUES ('20130309181219');

INSERT INTO schema_migrations (version) VALUES ('20130309181220');

INSERT INTO schema_migrations (version) VALUES ('20130309181221');

INSERT INTO schema_migrations (version) VALUES ('20130309181222');

INSERT INTO schema_migrations (version) VALUES ('20130309181223');

INSERT INTO schema_migrations (version) VALUES ('20130309181224');

INSERT INTO schema_migrations (version) VALUES ('20130309181225');

INSERT INTO schema_migrations (version) VALUES ('20130309181226');

INSERT INTO schema_migrations (version) VALUES ('20130309181227');

INSERT INTO schema_migrations (version) VALUES ('20130309181228');

INSERT INTO schema_migrations (version) VALUES ('20130309181229');

INSERT INTO schema_migrations (version) VALUES ('20130309181230');

INSERT INTO schema_migrations (version) VALUES ('20130309181231');

INSERT INTO schema_migrations (version) VALUES ('20130309181232');

INSERT INTO schema_migrations (version) VALUES ('20130309181233');

INSERT INTO schema_migrations (version) VALUES ('20130309181234');

INSERT INTO schema_migrations (version) VALUES ('20130309181235');

INSERT INTO schema_migrations (version) VALUES ('20130309181236');

INSERT INTO schema_migrations (version) VALUES ('20130309181237');

INSERT INTO schema_migrations (version) VALUES ('20130309181238');

INSERT INTO schema_migrations (version) VALUES ('20130309181239');

INSERT INTO schema_migrations (version) VALUES ('20130309181240');

INSERT INTO schema_migrations (version) VALUES ('20130309181241');

INSERT INTO schema_migrations (version) VALUES ('20130309181242');

INSERT INTO schema_migrations (version) VALUES ('20130309181243');

INSERT INTO schema_migrations (version) VALUES ('20130309181244');

INSERT INTO schema_migrations (version) VALUES ('20130309181245');

INSERT INTO schema_migrations (version) VALUES ('20130311194800');

INSERT INTO schema_migrations (version) VALUES ('20130315120127');

INSERT INTO schema_migrations (version) VALUES ('20130319090055');

INSERT INTO schema_migrations (version) VALUES ('20130320183734');

INSERT INTO schema_migrations (version) VALUES ('20130325092239');

INSERT INTO schema_migrations (version) VALUES ('20130327183519');

INSERT INTO schema_migrations (version) VALUES ('20130330104711');

INSERT INTO schema_migrations (version) VALUES ('20130330111624');

INSERT INTO schema_migrations (version) VALUES ('20130330120433');

INSERT INTO schema_migrations (version) VALUES ('20130330150339');

INSERT INTO schema_migrations (version) VALUES ('20130403150926');

INSERT INTO schema_migrations (version) VALUES ('20130411073012');

INSERT INTO schema_migrations (version) VALUES ('20130411073819');

INSERT INTO schema_migrations (version) VALUES ('20130411181020');

INSERT INTO schema_migrations (version) VALUES ('20130413124632');

INSERT INTO schema_migrations (version) VALUES ('20130413140014');

INSERT INTO schema_migrations (version) VALUES ('20130425121754');

INSERT INTO schema_migrations (version) VALUES ('20130427160851');

INSERT INTO schema_migrations (version) VALUES ('20130429132859');

INSERT INTO schema_migrations (version) VALUES ('20130501154747');

INSERT INTO schema_migrations (version) VALUES ('20130501161436');

INSERT INTO schema_migrations (version) VALUES ('20130505144517');

INSERT INTO schema_migrations (version) VALUES ('20130516154732');

INSERT INTO schema_migrations (version) VALUES ('20130518054711');

INSERT INTO schema_migrations (version) VALUES ('20130518104042');

INSERT INTO schema_migrations (version) VALUES ('20130518111321');

INSERT INTO schema_migrations (version) VALUES ('20130518112539');

INSERT INTO schema_migrations (version) VALUES ('20130518112733');

INSERT INTO schema_migrations (version) VALUES ('20130518133636');

INSERT INTO schema_migrations (version) VALUES ('20130521181445');

INSERT INTO schema_migrations (version) VALUES ('20130525092741');

INSERT INTO schema_migrations (version) VALUES ('20130525135123');

INSERT INTO schema_migrations (version) VALUES ('20130525183625');

INSERT INTO schema_migrations (version) VALUES ('20130525190345');

INSERT INTO schema_migrations (version) VALUES ('20130526171102');

INSERT INTO schema_migrations (version) VALUES ('20130619223318');

INSERT INTO schema_migrations (version) VALUES ('20130623190935');

INSERT INTO schema_migrations (version) VALUES ('20130624180612');

INSERT INTO schema_migrations (version) VALUES ('20130626224649');

INSERT INTO schema_migrations (version) VALUES ('20130627011053');

INSERT INTO schema_migrations (version) VALUES ('20130627012417');

INSERT INTO schema_migrations (version) VALUES ('20130627013814');

INSERT INTO schema_migrations (version) VALUES ('20130627021950');

INSERT INTO schema_migrations (version) VALUES ('20130627022031');

INSERT INTO schema_migrations (version) VALUES ('20130629180008');

INSERT INTO schema_migrations (version) VALUES ('20130629222429');

INSERT INTO schema_migrations (version) VALUES ('20130703015606');

INSERT INTO schema_migrations (version) VALUES ('20130704221234');

INSERT INTO schema_migrations (version) VALUES ('20130704223019');

INSERT INTO schema_migrations (version) VALUES ('20130704233952');

INSERT INTO schema_migrations (version) VALUES ('20130705000315');

INSERT INTO schema_migrations (version) VALUES ('20130705000522');

INSERT INTO schema_migrations (version) VALUES ('20130705001644');

INSERT INTO schema_migrations (version) VALUES ('20130707020219');

INSERT INTO schema_migrations (version) VALUES ('20130707071143');

INSERT INTO schema_migrations (version) VALUES ('20130707073154');

INSERT INTO schema_migrations (version) VALUES ('20130707073214');

INSERT INTO schema_migrations (version) VALUES ('20130707121819');

INSERT INTO schema_migrations (version) VALUES ('20130707130145');

INSERT INTO schema_migrations (version) VALUES ('20130707200030');

INSERT INTO schema_migrations (version) VALUES ('20130711083240');

INSERT INTO schema_migrations (version) VALUES ('20130711110721');

INSERT INTO schema_migrations (version) VALUES ('20130712003821');

INSERT INTO schema_migrations (version) VALUES ('20130713053828');

INSERT INTO schema_migrations (version) VALUES ('20130717093608');

INSERT INTO schema_migrations (version) VALUES ('20130717124249');

INSERT INTO schema_migrations (version) VALUES ('20130718062408');

INSERT INTO schema_migrations (version) VALUES ('20130718171707');

INSERT INTO schema_migrations (version) VALUES ('20130722054613');

INSERT INTO schema_migrations (version) VALUES ('20130722113657');

INSERT INTO schema_migrations (version) VALUES ('20130723155459');

INSERT INTO schema_migrations (version) VALUES ('20130723163451');

INSERT INTO schema_migrations (version) VALUES ('20130723174945');

INSERT INTO schema_migrations (version) VALUES ('20130723201948');

INSERT INTO schema_migrations (version) VALUES ('20130726020045');

INSERT INTO schema_migrations (version) VALUES ('20130726021113');

INSERT INTO schema_migrations (version) VALUES ('20130729173411');

INSERT INTO schema_migrations (version) VALUES ('20130731140148');

INSERT INTO schema_migrations (version) VALUES ('20130731144655');

INSERT INTO schema_migrations (version) VALUES ('20130808040207');

INSERT INTO schema_migrations (version) VALUES ('20130808040934');

INSERT INTO schema_migrations (version) VALUES ('20130808041102');

INSERT INTO schema_migrations (version) VALUES ('20130808091709');

INSERT INTO schema_migrations (version) VALUES ('20130813051454');

INSERT INTO schema_migrations (version) VALUES ('20130813052255');

INSERT INTO schema_migrations (version) VALUES ('20130814073240');

INSERT INTO schema_migrations (version) VALUES ('20130814165800');

INSERT INTO schema_migrations (version) VALUES ('20130814184014');

INSERT INTO schema_migrations (version) VALUES ('20130814184856');

INSERT INTO schema_migrations (version) VALUES ('20130816102141');

INSERT INTO schema_migrations (version) VALUES ('20130906160600');

INSERT INTO schema_migrations (version) VALUES ('20130910061902');

INSERT INTO schema_migrations (version) VALUES ('20130915122325');

INSERT INTO schema_migrations (version) VALUES ('20131008230721');

INSERT INTO schema_migrations (version) VALUES ('20131102013808');

INSERT INTO schema_migrations (version) VALUES ('20131102051314');

INSERT INTO schema_migrations (version) VALUES ('20131103092810');

INSERT INTO schema_migrations (version) VALUES ('20131117151157');

INSERT INTO schema_migrations (version) VALUES ('20131201220642');

INSERT INTO schema_migrations (version) VALUES ('20131205080847');

INSERT INTO schema_migrations (version) VALUES ('20131205081224');

INSERT INTO schema_migrations (version) VALUES ('20131206232738');

INSERT INTO schema_migrations (version) VALUES ('20131216082712');

INSERT INTO schema_migrations (version) VALUES ('20131218090356');

INSERT INTO schema_migrations (version) VALUES ('20131218095441');

INSERT INTO schema_migrations (version) VALUES ('20131218122344');

INSERT INTO schema_migrations (version) VALUES ('20131226003349');

INSERT INTO schema_migrations (version) VALUES ('20131228215205');

INSERT INTO schema_migrations (version) VALUES ('20131229043925');

INSERT INTO schema_migrations (version) VALUES ('20131229051532');

INSERT INTO schema_migrations (version) VALUES ('20131229052255');

INSERT INTO schema_migrations (version) VALUES ('20140104051104');

INSERT INTO schema_migrations (version) VALUES ('20140104051454');

INSERT INTO schema_migrations (version) VALUES ('20140104054300');

INSERT INTO schema_migrations (version) VALUES ('20140118103543');

INSERT INTO schema_migrations (version) VALUES ('20140118210327');

INSERT INTO schema_migrations (version) VALUES ('20140118211222');

INSERT INTO schema_migrations (version) VALUES ('20140118225716');

INSERT INTO schema_migrations (version) VALUES ('20140119035828');

INSERT INTO schema_migrations (version) VALUES ('20140120075042');

INSERT INTO schema_migrations (version) VALUES ('20140122022049');

INSERT INTO schema_migrations (version) VALUES ('20140122110937');

INSERT INTO schema_migrations (version) VALUES ('20140122132326');

INSERT INTO schema_migrations (version) VALUES ('20140122133530');

INSERT INTO schema_migrations (version) VALUES ('20140122140909');

INSERT INTO schema_migrations (version) VALUES ('20140128145357');

INSERT INTO schema_migrations (version) VALUES ('20140208021954');

INSERT INTO schema_migrations (version) VALUES ('20140217051836');
