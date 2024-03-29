PGDMP     (    :                {            pac02-sql_used_cars    15.2    15.2 4    E           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            F           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            G           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            H           1262    17828    pac02-sql_used_cars    DATABASE     �   CREATE DATABASE "pac02-sql_used_cars" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_World.1252';
 %   DROP DATABASE "pac02-sql_used_cars";
                postgres    false            �            1255    17901 Z   haversine_distance(double precision, double precision, double precision, double precision)    FUNCTION     P  CREATE FUNCTION public.haversine_distance(lat1 double precision, lon1 double precision, lat2 double precision, lon2 double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	lat1 float := radians(lat1);
	lon1 float := radians(lon1);
	lat2 float := radians(lat2);
	lon2 float := radians(lon2);

	dlon float := lon2 - lon1;
	dlat float := lat2 - lat1;
	a float;
	b float;
	c float;
	r float := 6371;
	jarak float;
BEGIN
	-- haversine formula
	a := sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;
	c := 2 * asin(sqrt(a));
	jarak := r * c;
RETURN
	jarak;
END;
$$;
 �   DROP FUNCTION public.haversine_distance(lat1 double precision, lon1 double precision, lat2 double precision, lon2 double precision);
       public          postgres    false            �            1259    17866    ads    TABLE     C  CREATE TABLE public.ads (
    ad_id integer NOT NULL,
    user_id integer NOT NULL,
    car_id integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    mileage_km integer NOT NULL,
    color text NOT NULL,
    transmission text NOT NULL,
    negotiable boolean NOT NULL,
    post_date date NOT NULL
);
    DROP TABLE public.ads;
       public         heap    postgres    false            �            1259    17865    ads_ad_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ads_ad_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.ads_ad_id_seq;
       public          postgres    false    221            I           0    0    ads_ad_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.ads_ad_id_seq OWNED BY public.ads.ad_id;
          public          postgres    false    220            �            1259    17857    cars    TABLE     �   CREATE TABLE public.cars (
    car_id integer NOT NULL,
    brand text NOT NULL,
    model text NOT NULL,
    body_type text NOT NULL,
    price_idr integer NOT NULL,
    year integer NOT NULL
);
    DROP TABLE public.cars;
       public         heap    postgres    false            �            1259    17830    cities    TABLE     �   CREATE TABLE public.cities (
    city_id integer NOT NULL,
    city_name text NOT NULL,
    latitude numeric(8,6) NOT NULL,
    longitude numeric(9,6) NOT NULL
);
    DROP TABLE public.cities;
       public         heap    postgres    false            �            1259    17841    users    TABLE     �   CREATE TABLE public.users (
    user_id integer NOT NULL,
    name text NOT NULL,
    phone_number text NOT NULL,
    city_id integer NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    17907    avg_price_per_city    VIEW     [  CREATE VIEW public.avg_price_per_city AS
 SELECT cities.city_name,
    avg(cars.price_idr) AS avg_price
   FROM (((public.cars
     LEFT JOIN public.ads ON ((cars.car_id = ads.car_id)))
     LEFT JOIN public.users ON ((ads.user_id = users.user_id)))
     LEFT JOIN public.cities ON ((users.city_id = cities.city_id)))
  GROUP BY cities.city_name;
 %   DROP VIEW public.avg_price_per_city;
       public          postgres    false    221    215    221    219    215    219    217    217            �            1259    17885    bids    TABLE     �   CREATE TABLE public.bids (
    bid_id integer NOT NULL,
    user_id integer NOT NULL,
    ad_id integer NOT NULL,
    bid_price_idr integer NOT NULL,
    bid_date date NOT NULL
);
    DROP TABLE public.bids;
       public         heap    postgres    false            �            1259    17884    bids_bid_id_seq    SEQUENCE     �   CREATE SEQUENCE public.bids_bid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.bids_bid_id_seq;
       public          postgres    false    223            J           0    0    bids_bid_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.bids_bid_id_seq OWNED BY public.bids.bid_id;
          public          postgres    false    222            �            1259    17902 
   car_cities    VIEW     T  CREATE VIEW public.car_cities AS
 SELECT cities.city_name,
    cars.brand,
    cars.model,
    cars.year,
    cars.price_idr
   FROM (((public.cars
     LEFT JOIN public.ads ON ((cars.car_id = ads.car_id)))
     LEFT JOIN public.users ON ((ads.user_id = users.user_id)))
     LEFT JOIN public.cities ON ((users.city_id = cities.city_id)));
    DROP VIEW public.car_cities;
       public          postgres    false    215    215    217    217    219    219    219    219    219    221    221            �            1259    17856    cars_car_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cars_car_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.cars_car_id_seq;
       public          postgres    false    219            K           0    0    cars_car_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.cars_car_id_seq OWNED BY public.cars.car_id;
          public          postgres    false    218            �            1259    17829    cities_city_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.cities_city_id_seq;
       public          postgres    false    215            L           0    0    cities_city_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;
          public          postgres    false    214            �            1259    17927    model_bid_dates_6m    VIEW     +  CREATE VIEW public.model_bid_dates_6m AS
 SELECT cars.model,
    bids.bid_price_idr,
    bids.bid_date
   FROM ((public.bids
     LEFT JOIN public.ads ON ((bids.ad_id = ads.ad_id)))
     LEFT JOIN public.cars ON ((ads.car_id = cars.car_id)))
  WHERE (bids.bid_date >= (now() - '6 mons'::interval));
 %   DROP VIEW public.model_bid_dates_6m;
       public          postgres    false    223    221    221    223    219    223    219            �            1259    17918 
   yaris_bids    VIEW        CREATE VIEW public.yaris_bids AS
 SELECT cars.model,
    bids.user_id,
    bids.bid_date,
    bids.bid_price_idr
   FROM ((public.cars
     JOIN public.ads ON ((cars.car_id = ads.car_id)))
     JOIN public.bids ON ((ads.ad_id = bids.ad_id)))
  WHERE (cars.model ~~ 'Toyota Yaris'::text);
    DROP VIEW public.yaris_bids;
       public          postgres    false    223    221    221    223    223    223    219    219            �            1259    17923    user_yaris_bid_count    VIEW     �   CREATE VIEW public.user_yaris_bid_count AS
 SELECT yaris_bids.user_id,
    count(yaris_bids.user_id) AS bid_count
   FROM public.yaris_bids
  GROUP BY yaris_bids.model, yaris_bids.user_id;
 '   DROP VIEW public.user_yaris_bid_count;
       public          postgres    false    226    226            �            1259    17840    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    217            M           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    216            �           2604    17869 	   ads ad_id    DEFAULT     f   ALTER TABLE ONLY public.ads ALTER COLUMN ad_id SET DEFAULT nextval('public.ads_ad_id_seq'::regclass);
 8   ALTER TABLE public.ads ALTER COLUMN ad_id DROP DEFAULT;
       public          postgres    false    220    221    221            �           2604    17888    bids bid_id    DEFAULT     j   ALTER TABLE ONLY public.bids ALTER COLUMN bid_id SET DEFAULT nextval('public.bids_bid_id_seq'::regclass);
 :   ALTER TABLE public.bids ALTER COLUMN bid_id DROP DEFAULT;
       public          postgres    false    223    222    223            �           2604    17860    cars car_id    DEFAULT     j   ALTER TABLE ONLY public.cars ALTER COLUMN car_id SET DEFAULT nextval('public.cars_car_id_seq'::regclass);
 :   ALTER TABLE public.cars ALTER COLUMN car_id DROP DEFAULT;
       public          postgres    false    219    218    219            �           2604    17833    cities city_id    DEFAULT     p   ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);
 =   ALTER TABLE public.cities ALTER COLUMN city_id DROP DEFAULT;
       public          postgres    false    214    215    215            �           2604    17844    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    216    217    217            @          0    17866    ads 
   TABLE DATA           �   COPY public.ads (ad_id, user_id, car_id, title, description, mileage_km, color, transmission, negotiable, post_date) FROM stdin;
    public          postgres    false    221   �@       B          0    17885    bids 
   TABLE DATA           O   COPY public.bids (bid_id, user_id, ad_id, bid_price_idr, bid_date) FROM stdin;
    public          postgres    false    223   �H       >          0    17857    cars 
   TABLE DATA           P   COPY public.cars (car_id, brand, model, body_type, price_idr, year) FROM stdin;
    public          postgres    false    219   5Z       :          0    17830    cities 
   TABLE DATA           I   COPY public.cities (city_id, city_name, latitude, longitude) FROM stdin;
    public          postgres    false    215   1\       <          0    17841    users 
   TABLE DATA           E   COPY public.users (user_id, name, phone_number, city_id) FROM stdin;
    public          postgres    false    217   �]       N           0    0    ads_ad_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.ads_ad_id_seq', 50, true);
          public          postgres    false    220            O           0    0    bids_bid_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.bids_bid_id_seq', 502, true);
          public          postgres    false    222            P           0    0    cars_car_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.cars_car_id_seq', 1, false);
          public          postgres    false    218            Q           0    0    cities_city_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.cities_city_id_seq', 1, false);
          public          postgres    false    214            R           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);
          public          postgres    false    216            �           2606    17873    ads ads_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (ad_id);
 6   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_pkey;
       public            postgres    false    221            �           2606    17890    bids bids_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_pkey PRIMARY KEY (bid_id);
 8   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_pkey;
       public            postgres    false    223            �           2606    17864    cars cars_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (car_id);
 8   ALTER TABLE ONLY public.cars DROP CONSTRAINT cars_pkey;
       public            postgres    false    219            �           2606    17839 $   cities cities_latitude_longitude_key 
   CONSTRAINT     n   ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_latitude_longitude_key UNIQUE (latitude, longitude);
 N   ALTER TABLE ONLY public.cities DROP CONSTRAINT cities_latitude_longitude_key;
       public            postgres    false    215    215            �           2606    17837    cities cities_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);
 <   ALTER TABLE ONLY public.cities DROP CONSTRAINT cities_pkey;
       public            postgres    false    215            �           2606    17850    users users_phone_number_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key UNIQUE (phone_number);
 F   ALTER TABLE ONLY public.users DROP CONSTRAINT users_phone_number_key;
       public            postgres    false    217            �           2606    17848    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    217            �           2606    17879    ads ads_car_id_fkey    FK CONSTRAINT     t   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_car_id_fkey FOREIGN KEY (car_id) REFERENCES public.cars(car_id);
 =   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_car_id_fkey;
       public          postgres    false    221    3228    219            �           2606    17874    ads ads_user_id_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 >   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_user_id_fkey;
       public          postgres    false    217    3226    221            �           2606    17896    bids bids_ad_id_fkey    FK CONSTRAINT     r   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES public.ads(ad_id);
 >   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_ad_id_fkey;
       public          postgres    false    223    3230    221            �           2606    17891    bids bids_user_id_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 @   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_user_id_fkey;
       public          postgres    false    217    223    3226            �           2606    17851    users users_city_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_city_id_fkey;
       public          postgres    false    215    3222    217            @   �  x��Zێ�6}~�~��x�(=�R hQ�hҢ�"�ήv})�v���;"%���"��Ь(������N_O����;�/�(y]�럺kq�����p޽�����v�k��m����S���ӵ��Ӷ��g|�mx��G����_�K?o�ԝq��������J�eY<�/��؍j�J���Y	Ӯ�	D)䦔�2�;:�RM��=/�s����{_�-j���q��[{���`�%��0���E"6�oʊIhZ�>�w��;J�I���=�����pT灕"R�m�����	�g`VO�.��]�T��EY��[?��]�½R.x���蠲�g���w����Y�z݄�|=�Ǉ��E��?�O�/O�x����8k*�Ī|א�s�_-A��j<�'Я�v�jm�j{�t���WsX��3_��I�l<p�DG�]�0�ʍ�LC�A����@ߜ��x*T��G�J���͖����� K"`��5�M��`<��$⣩VT�y�B8��k!�ZP%��Ɠ��U����K��"=�,I�r�ۛoQ%I3^�.��y��ƈLǾ�:��c_O���@�%�CSa�L����Sd�z�����|sJ-+H�Vd���B큱
�r��e>�:H^&8� [<���7}2�����zI<Yf�%
�p.��$(\�nҌ�����w�H�%� �N�P��@�
�K
�,WM��H=m8^Va	�d�RS�"�:��;-����!�̴����߻(��y�P���fE3� �6MDo�����\�W_��iF�S���2���-�k	��=qna)��?3Q�נ�4z������E_2�����|s��{9����������r�s�5G����� 2��0�[Um�´���~��i�Tq�WrC`��M,�D	��?,͡�@�]4a��R9#��눫����LpP�yS���ܟ�V����+�Jï��u.�i%��T>��^ń�=|�
8�I�)�7_�V1(\UVK"AHu,d�����#q�3T��G�P +��V�H�-�u]�I�F��	Z >C�~?>\:�t!�t�I?��8� ���l�TP���P˚M\��Ud�RF�����u$A�>�鱆�ᐎ?w�������S�`�{�PG��*د"=�m�z0��!f�ٵ#S���0OV<pF�	:��u����D��D"5n�v�dT�5�1æJ{�F�nӨ	��x�K&Umq�*j�<�0.���@�,�1�ܫ�Kx��rh
d�O��l)Ov�t�	�6�F��v�J�s�N�����7��Y�ig�{��� ��n?
q~��`R5��Z~�CH����$�-,H"�-���4���Rku/��xJ�L����ٚ-j�I5x>)g3m�ͮNBŲK��U����D�0v�f� �0PƇ��|�2�6Zg���
��R��W�/��E�p�S�ު���㶮+� �B9��7'\�h�v���iU8�Z�9��	�i�8ޏ#Mi�o�Q.i�t1Ls��j&h0�5.�E�.�D�O )Ӊ�����2���k�e�d�?G3��D��-�1̔Ĕ�ʰ�"���
+|3��8�G��hڐU�)���PKV�F�
��<�����j�@�����^847R�V4�ww�vMv���m^4
�}��������~���A���],�A�Ĭ��V%1z@I�[D��1�V����V1�fy0ߛç��RCQ�������c2�sß��P���t�!��S�T1�t��\V��!$��+��To����2��L�P������s_�x��]@�F��Μ�k�~�01YR.�5���:�fJC%��h�
��U[Ȓ�6��1+E�cw6��t�� �q*$ ��Y�c�ٸLN1�=3e_G��MIm��ژοn�"�`F���:mM��P�c�E�.�_�!wn���}�Ɠ�K�a���)]f�2�'�,�Me[����1���]S      B      x�u[Y�������L�~���Vu�H�0�P.\�AV��]�j���k��������U�U�c��+�n�]�\�=���ݯѹv�Ҹ�5���ժ=;'v�z����v�k���H[�.vo��Z��(�Z��U���l޵�e�a��|��3���5��^�M�֌�����U�m�Dp�7����k<��aC ���g�}�g����n���3�Y��V�п2�#tl{�Bj3�Y�͋N�`�x�y[�Z����RoH�p�E���vm(�@��%�~�C��q�TY����h�m������i�vI����m_�X�p[�{��3���@mZ-a�NR)?(�GsǕ���݃��l��|hǝo�z�K߇/k������Í�m� )������pA���m:!�,�X;��s�x���.Ԣ��s����zN<�&�-q����&��K��=��R��vi��J�]Ⱦ�k1b\���5�v��Qk�wS1�zF�C|0x\��`5z�Q�)3�)��{�� ���U�ÖbCLAD��|�݈����ֆ�	�//�N链�rمԀP��!N�}ɲgt4�g �h����w94N+�[Z�g���U�- 
>�Fe��\��c���I�Ri��=�TI�*�iB��r�O�)�O��}�b��'�Q�xr�9�L�16�~#�}�膹��l%^��.���㎫x|a!d�ơ����.���칶��獔	�$D��+�\,����>jk��|�A�
U3uxR�#���0��n��<{�˳�����7�O�1�|�h7�{jf'x���'s�|� �N`#+�:���S�� l0hT���!B��5�#����B��ɑ��!Ax�	#zz�$�����	�6� �Q��8�{�DD��Nq/��58ř|���5X
nD��X3�� X�zؕ��2y�/���K�7%}�R	d�C1�xS����#� � :V^8�rģZ��*�u�҆š4�'{���{!ⓐ�]��Pr��6����
,8�O�"���)�g��*�	|��d\��`�k�UH�����F�*���<n�΃UL� H<H�2�.�����^r�s%��{mz4�#�P�ߑ�r��ߔ�(��	�	�aNrzx��4YV@v]�"!���O�: e&�\> �Vs|�_D�]Y��
��%�%��%�k|���^�j
R���n�Щ�&�=��7y�J��h��E��8 Q�Nroʃ�]U�*�`����)�*J�{	�?m���H����ӓ��`��%�W��)ɰ�,��-%>#�8r�Wv��B+T�+GiPV�Kvf�����N�3_�d�Gv�L��`y*�<kA�DPGIa�7��ͭgg�X -cI\	4C  �0������>��R���
�}ŨDE^@�'�tY�����N,.�d@�1e:�y*���\�P�3�X�Q�c�`}�܁;3	
wf>c�б�:�̻;q��`�J�W�q��2�PQ��7�<��Tf��sxe�(��թpg/PF9T�%�AA
�"B��c!z|��ag@���*���PajI!�T	SG%�1T�rNvm�rFX19R|%��P�O�0���T�C���HɢA�\/f�򗱩��>>��d��]�s��̃`_���)�Ct��(�mΧ8�L� "-�l'n.��qr⨌'OFSƵV�/��6`�(�vU���ķR�oI��/N����b��%��������a@�]��Rǡ���[��9n �q���+�����b�x&q<z~
������<&����n�~�#
�&oD3��v>��@�}�m+�ւe�Q��_\��W"�I�z��'��<�²�V̥�;�ד�tOM�ր�Ŏ���:�%E����=�p-2��gV��#%	Y��S�pX��j,����nⵞ$�7�0G�G��e�ٲ���~�9�/R;����rG7V7�	�%��Z"�RꀘY5+6��f��U��1��y�-T�}���X�����*!3������n���J��ru���Q?�'��p��)O=�H����ojH���+�vE�PP��]��q9 I'C	@�K���5���3V;6��w&�l��zdi9�:S��%l�{;�?׌x��^P�l#�Y(���-�t�{!, V�Hn&�ڠ},ו:J�F?^M1ڈ)�sf�h�pP�R��D�]3�Xj'W��0���w
��p�]��E�G����vr��ߣx9c��1B���ބRʆȎ�hU:<ۉ#��\ld�h����4؇+����YȷKM���;�0?�yg�`�w��ɏ��g̈��@jO�\l��
J�, C��Ҙ��<ȣ44
�	����)W�r��<�-	�A�����&���,�i��x��P�T��9��9*�Q��)��I���*���᧒e�1n«��֪��fD{&�o�j���K\r�C�>��L��IK���s][��=í[�}�dr ����)����v�Ƶ𱻢����1����K� 	 ��΃i"��``��3c��z��rMm�-K�����S�KIl[`��6�)z����"c"��!�0���Ô���͇7u)�X���i<�0�<`Nw�E��7�)2.���gK��y����<k�� �x��2��w� �r%Ի�X?��y	�8^�3%��E����V�ޔ�b�U���Cxg�xS�݅Dl�Z*YɧU�w���d��h(��71H��_�N_`�H�VEԨ���T���!�bS��i��/���b[cqj�X��H����ٟQvZ);�.�_,_'˸�ڞ���U��ʸ���Uغ�`L ����T^�ʥi�E)5��� Ѯ�X�*�, ��Q���ا���X-e�]�D����@OL��BR݁@���=J^i�� W*�FRl[��7��| .vx�օ�|Fc;�K�����EfC��֜��/-��ȇI�3�)�����Z�\��HEip�p��A
K�seuD�I>���# �z��f}?���v���J`fҔz �Wg2a~:H\n�9	^��}<�(�������d��5c��������<�,ƨsi�E�U1[f1C6B�i�2� �=�Z���?�y� �इ�����@[����w&0U�!.���92������j$50�]r��&��X�Qb��p0a~����p��Ô�``����"����<�He����*ə[�O�>��M��O/�HK6^%W���-Y��ҍ.i��K�%O:p�>�y䓖��OZ�]W���$��ꊶM��8���	��1!T\�3p��i�p��=���?-CtN΢�l��а�������N�¦�%�"꠽oٕX��!�F�Q��InX���3�T�pUd�ڗF]�[)�^#!X��s�zc[!�#�[�Dʭ}֔I`��[�c*:�K[��+d�<� a��n3�Dy��\^�<���O^�џ����i�y�I~{+�������O{� ����4��~JˢI����Ú��X�U����
��E��n^��9)
,o���Đ�j��vB	\��:%/J娾�ů�_�
o���-,��2Q��4�HЫ�O����:bq�3�����~�w��o�f�8�R����i�zj��>Tc�F'���+�F�]~+���H�q�K͘�E`tB��7K��o������|S7�����:��!��;�Ni�6G����|9��d��'�
��Oc-1�Z=S~�,U:r�U�ѹ��aFI�Y`�[�,惚����ӷ\��^{���gg�%^fצO�ŉ��;/�q��i�
l'm�0�({����	=�k\���	e��ؼ�K���SO9ƫ��	�T�n'81�2�k�Q���z���6c���B�p��R� �E�Y�|���?LM���Hew���d 8�c��˃�x1@��KV"�s"
,i&Xߪ�i0�>�w'���	~9U�DQ���.�ۘ27�?I-�v���?EO�h�2����g��Y?��12P��>��v ����'?wʙ�/?� S  �  ���A"�g
A��˿��wj2�\���S�mfi��Iؓ�s/���;�Z��K���U�c�O��5��������hì_:��c�����a+�3FOZ�Ktq�w`�%Ifb�Ǫ3�,���㩽�R4T�1��>���7�U--e�د�1_(��P��4� <x�ҿ���$��|��4:��+����w�|ia��q�pX[ҷ����Wf�������<�i�p&; 4���'\�g;\�J+����l�;]�2G؏~
��c	K����/E�ԏ�hǬ%�#-M�Ef���h�k�� )`�+#�X��� ���Wq����������      >   �  x����j�@��w��/а3��@(J��-�f�G$X�����US͈�nt!�⛣�s�cT������c�+o������ӟ�|V�~�i�@���LK�ӈ[�-�3�'��NvT'��z}̜FF'u:�xlIknbj�ι�)	P��G N�y~�y�o�g�i����f)�I� �-7�)J6֫��=�����cv}|�vD#*B�I��%ɏ0}�%�` ��#J�Pr��v�N-�?(Ll�Du�hT�22��3�l�^���h��r���tY}�:��2�ai��D�x���9��e�f�X0�T�X�����c��}Χ�u�����S�Q*���mh�U�G؀����𖶝�I�2f����2�l=̞�yf��/�4E�z�2�y��-����>�T���<l2φ�`�e2zn���ɐ�꽦0N��z�8����1�����C%֬*(�|p VP��!�TA��"p��x�� �/`�j�      :   b  x�U��j�0����G3��aO[�����̒LR78�!oߑ���	��ͧ�3v�ߓ��cG��6_l�^4b�T�C�X8A����L6ڂ	˂sNH�a~��k2���KrzƻϓM64� ��ƽ�4.�����ǆIS��R��{���l8t/9ւ�����
pSeU�y��v��TT]\�ĵN����>\��M暉Z"D����}�Ɔ��k��rr9*x���7�/� VX�a� ���ě��OS?}��VDW�^6}4�ة?���ֈ�Ϫ��7C�n�v�;�����";���_O~t���/�U�_c���1��|�<��ߟ��W��R�ӠD"�ZÿB�Ot�)      <   E  x�]W�r[7]�_��TS7��c)[��r4v<�I�
"y������ HQ)/�*�@w�G�+��y�w�s��z}إ���)~%���<F�)#5��˅b�I�jL�e����2��s�3ƹzR���?�S��J合�1t1xQv��c��i���Jg���{isƫ�e�v�����<�V��\D��0m�^8v3�����:ԓ^_�`<J:������֖?��ay����.\G��^v7c�s�����~%e�=���ӳa����z�5���w����q�p\a�V���}Fi�ߥ�{���嘃��H��R�/i���Ч�Ԇ,\1c�|l7*��_��W����uIg��L:�q�2o�3�s!Do�u��h��i��}���ݼC���:�`A����>-Q�C��6Vc<���8&5����O�y���tL��r�F�M;�������ٟ�ų4A�*�_It��}X�S�_��\g ^�;*Εf#�#���x��+�������B	Bs�R�N��S� B+[�J�w�C��o�~�=�P)�A����M��a��+�]��S�v>jY�P�}p��+�#?\b+ϰ�4<���D�h����%TW=�y~�g�`$@�VU@ʱ_6#(z�fG�J7q �}0��Gy�Ǽ����Y��ihJ�����{B�>�_1�!'�)e\��~����s�� �o�u� �}CU8e�v�:g�iV!�m�ë��N�X�����)��i<[�V��j˭��Y�~�&p�#����2õ�h���m��8���x�PN�l>p���DG�q87��#�~>�c��Dc���!F�H��W�f@y�"���nV�݊�\�!|Fw��ҷ��}Mi�&N��<=n��b�1��t`���(��"��=Ye�=Z���0~:��J	�m�\8k�Z��7�~3;�&�Lc��$v�3�|8A��5�����X�1��	���i+g�f�y�$��a-�q4�\F*�A����ɓMEؔ��(u���ง��X0�ApZQ-v�q��H��'�7��uJ��,�	�q5��� �t�3^�=�Z�f:��~5L���iD0Li�*1Jp���:oN+�5-7J�Mc&��@�ۄ���*x�)�;��{E�V�݀�X3g��-`�_4o�<|��8	Ā݅�JZ>��b�������G�����^h��Q��$�6���3����N:���cos?m`4o�������*�Z,�B$�Igo�=C$@�3e˕*�Y�����(Rr�p\[56��t&7mlB+;'t�{�F *9g��������ƅ�����<�?��r�aD��r�)�����$s���*D� ��	�a�8�1�sh�ц�^�i;C+)�ۘ��ǅ&�0ږ��}1�Oi�4�hA�
�a�r$�/8�.��p/����-�"�ǒx������\ĵk�T�p����쯝�s1v[������	�o��ݮ�,�N�Jm�K�;z�o� b?��<Ȳh;�c	D	�������*E	VWFxZ�[�Ln�/�H��9����u=-���%�Pb�8���-������!�5芐�̦p��4.[y/vm%݈>���:ޱ[d�K=�� �Dʴ%�=�]����#� �
ӓ*���!�aJ���o�����x�_�1-i� i�0eG9,^7,���>�m!7��"�+�f�\��P�T�J���l�6]@Ɣ�`\� |��_���p$���J-c�I�68�M_�@$�ڴ�U���]��XIn8 �"�����6=78�.|�pct!�q�M��~i���7w���pGQ{���ρ˄�5�P�o �}&�mڲ+|Ҳ�!�6��h�O�O���	�/�	}�fG ��j���Z厴���Uh J�9=��9U
�p!OVY/�Gaނ獃hE`o��V'V�%�s��5!�w2��1ɥ�Nx�)�V����GQ-��s���><�$�l��ѡt�ϔ@��K��[�*s�SĘGd���Ñ#l�7ŀ��x1
p��@��9܆��P^�J��:�Q����Aʢ<�~��/M� �D������X,����     