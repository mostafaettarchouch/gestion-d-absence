-- ------------------------------------------------------------
--  Schéma SQL corrigé et final – Projet « Gestion des absences – OFPPT Khénifra »
--  Basé sur le MLD fourni et les explications de l'utilisateur
-- ------------------------------------------------------------

CREATE DATABASE IF gestion_absence;
USE gestion_absence;

-- ------------------------------
-- Table : administrateur
-- ------------------------------
CREATE TABLE administrateur (
  admin_id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100),
  prenom VARCHAR(100),
  email VARCHAR(250),
  password_hash VARCHAR(250),
  telephone VARCHAR(20),
  date_creation DATE
);

-- ------------------------------
-- Table : formateurs
-- ------------------------------
CREATE TABLE formateurs (
  formateur_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT,
  nom VARCHAR(100),
  prenom VARCHAR(100),
  email VARCHAR(250),
  password_hash VARCHAR(250),
  telephone VARCHAR(20),
  specialite VARCHAR(250),
  date_recrutement DATE,
  FOREIGN KEY (admin_id) REFERENCES administrateur(admin_id)
);

-- ------------------------------
-- Table : filieres
-- ------------------------------
CREATE TABLE filieres (
  filiere_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT,
  intitule VARCHAR(250),
  description VARCHAR(250),
  duree_mois FLOAT,
  niveau VARCHAR(250),
  FOREIGN KEY (admin_id) REFERENCES administrateur(admin_id)
);

-- ------------------------------
-- Table : groupes
-- ------------------------------
CREATE TABLE groupes (
  groupe_id INT AUTO_INCREMENT PRIMARY KEY,
  filiere_id INT,
  code_groupe VARCHAR(150),
  annee_scolaire VARCHAR(150),
  semestre VARCHAR(50),
  effectif_prev INT,
  FOREIGN KEY (filiere_id) REFERENCES filieres(filiere_id)
);

-- ------------------------------
-- Table : stagiaires (chaque stagiaire appartient à un seul groupe)
-- ------------------------------
CREATE TABLE stagiaires (
  stagiaire_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT,
  groupe_id INT,
  id_inscription VARCHAR(30),
  cne VARCHAR(30),
  nom VARCHAR(100),
  prenom VARCHAR(100),
  telephone VARCHAR(20),
  date_naissance DATE,
  sexe VARCHAR(10),
  adresse VARCHAR(250),
  FOREIGN KEY (admin_id) REFERENCES administrateur(admin_id),
  FOREIGN KEY (groupe_id) REFERENCES groupes(groupe_id)
);

-- ------------------------------
-- Table : modules
-- ------------------------------
CREATE TABLE modules (
  module_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT,
  nom_module VARCHAR(200),
  volume_horaire INT,
  FOREIGN KEY (admin_id) REFERENCES administrateur(admin_id)
);

-- ------------------------------
-- Table : salles
-- ------------------------------
CREATE TABLE salles (
  salle_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT,
  code_salle VARCHAR(150),
  capacite INT,
  FOREIGN KEY (admin_id) REFERENCES administrateur(admin_id)
);

-- ------------------------------
-- Table : enseignement
-- ------------------------------
CREATE TABLE enseignement (
  module_id INT,
  formateur_id INT,
  salle_id INT,
  groupe_id INT,
  PRIMARY KEY (module_id, formateur_id, salle_id, groupe_id),
  FOREIGN KEY (module_id) REFERENCES modules(module_id),
  FOREIGN KEY (formateur_id) REFERENCES formateurs(formateur_id),
  FOREIGN KEY (salle_id) REFERENCES salles(salle_id),
  FOREIGN KEY (groupe_id) REFERENCES groupes(groupe_id)
);

-- ------------------------------
-- Table : gestion_d_absence
-- ------------------------------
CREATE TABLE gestion_d_absence (
  stagiaire_id INT,
  formateur_id INT,
  heure_fin INT,
  presence VARCHAR(250),
  motif VARCHAR(250),
  justifie VARCHAR(250),
  PRIMARY KEY (stagiaire_id, formateur_id),
  FOREIGN KEY (stagiaire_id) REFERENCES stagiaires(stagiaire_id),
  FOREIGN KEY (formateur_id) REFERENCES formateurs(formateur_id)
);


-- ------------------------------------------------------------
--  Jeu de données d'exemple – Gestion des absences (OFPPT Khénifra)
--  Langue : Français
--  Hypothèses :
--    • Admin ID = 1
--    • 10 filières, 20 groupes (2 par filière)
--    • 20 formateurs
--    • 30 modules
--    • 300 stagiaires (30 par filière → 25+5 par groupe)
--    • 20 salles (14 cours, 4 info, 1 dev numérique, 1 labo)
-- ------------------------------------------------------------

-- =============================
-- 1) Administrateur (1)
-- -----------------------------
INSERT INTO administrateur (admin_id, nom, prenom, email, password_hash, telephone, date_creation)
VALUES (1, 'Super', 'Admin', 'admin@ofpptkhenifra.ma', 'hash_admin', '0600000000', CURRENT_DATE);

-- =============================
-- 2) Formateurs (20)
-- -----------------------------
INSERT INTO formateurs (formateur_id, admin_id, nom, prenom, email, password_hash, telephone, specialite, date_recrutement) VALUES
  (1, 1, 'Alami',    'Youssef',  'y.alami@ofppt.ma',    'hash1', '0600000001', 'Maths',        '2020-09-01'),
  (2, 1, 'Benzakour','Samira',   's.benzakour@ofppt.ma','hash2', '0600000002', 'Physique',     '2019-09-01'),
  (3, 1, 'Cherkaoui','Omar',     'o.cherkaoui@ofppt.ma','hash3', '0600000003', 'Réseaux',      '2018-09-01'),
  (4, 1, 'Dahbi',    'Meryem',   'm.dahbi@ofppt.ma',    'hash4', '0600000004', 'Dév. Web',     '2017-09-01'),
  (5, 1, 'El Fassi', 'Anas',     'a.fassi@ofppt.ma',    'hash5', '0600000005', 'Gestion',      '2021-02-15'),
  (6, 1, 'Fadili',   'Nadia',    'n.fadili@ofppt.ma',   'hash6', '0600000006', 'Anglais',      '2022-03-01'),
  (7, 1, 'Ghazali',  'Rachid',   'r.ghazali@ofppt.ma',  'hash7', '0600000007', 'BD',           '2016-10-01'),
  (8, 1, 'Hajji',    'Amina',    'a.hajji@ofppt.ma',    'hash8', '0600000008', 'Java',         '2015-09-01'),
  (9, 1, 'Idrissi',  'Karim',    'k.idrissi@ofppt.ma',  'hash9', '0600000009', 'Python',       '2020-01-10'),
  (10,1, 'Jabrane',  'Salma',    's.jabrane@ofppt.ma',  'hash10','0600000010', 'Sécurité',     '2019-05-01'),
  (11,1, 'Kadiri',   'Hassan',   'h.kadiri@ofppt.ma',   'hash11','0600000011', 'Cloud',        '2018-11-01'),
  (12,1, 'Labiri',   'Fatima',   'f.labiri@ofppt.ma',   'hash12','0600000012', 'DevOps',       '2017-04-01'),
  (13,1, 'Malki',    'Younes',   'y.malki@ofppt.ma',    'hash13','0600000013', 'IA',           '2022-09-01'),
  (14,1, 'Naoui',    'Leila',    'l.naoui@ofppt.ma',    'hash14','0600000014', 'Android',      '2023-01-15'),
  (15,1, 'Ouazzani', 'Reda',     'r.ouazzani@ofppt.ma', 'hash15','0600000015', 'iOS',          '2023-06-01'),
  (16,1, 'Qandil',   'Said',     's.qandil@ofppt.ma',   'hash16','0600000016', 'PHP',          '2021-07-01'),
  (17,1, 'Rifi',     'Nouhaila', 'n.rifi@ofppt.ma',     'hash17','0600000017', 'UX/UI',        '2020-12-01'),
  (18,1, 'Saidi',    'Adil',     'a.saidi@ofppt.ma',    'hash18','0600000018', 'C#',           '2016-03-01'),
  (19,1, 'Tahiri',   'Ilham',    'i.tahiri@ofppt.ma',   'hash19','0600000019', 'Big Data',     '2018-08-01'),
  (20,1, 'Zaoui',    'Othman',   'o.zaoui@ofppt.ma',    'hash20','0600000020', 'Electronique', '2015-01-01');

-- =============================
-- 3) Filières (10)
-- -----------------------------
INSERT INTO filieres (filiere_id, admin_id, intitule, description, duree_mois, niveau) VALUES
  (1,1,'Développement Digital','Conception d'applications','24','Technicien Spécialisé'),
  (2,1,'Réseaux Informatiques','Administration réseau','24','Technicien Spécialisé'),
  (3,1,'Maintenance Informatique','Support & hardware','18','Technicien'),
  (4,1,'Design Graphique','Infographie & PAO','18','Technicien'),
  (5,1,'Gestion des Entreprises','Comptabilité & RH','18','Technicien'),
  (6,1,'Marketing Digital','SEO/SEA & SMO','18','Technicien'),
  (7,1,'Électronique Industrielle','Circuits & PLC','24','Technicien Spécialisé'),
  (8,1,'Intelligence Artificielle','Data science & ML','24','Technicien Spécialisé'),
  (9,1,'Sécurité Informatique','Cybersecurity','24','Technicien Spécialisé'),
  (10,1,'Cloud Computing','Services & Virtualisation','24','Technicien Spécialisé');

-- =============================
-- 4) Groupes (20 ; 2 par filière)
-- -----------------------------
INSERT INTO groupes (groupe_id, filiere_id, code_groupe, annee_scolaire, semestre, effectif_prev) VALUES
  -- Filière 1
  (1, 1, 'DD-G1', '2025/2026', 'S1', 25),
  (2, 1, 'DD-G2', '2025/2026', 'S1', 5),
  -- Filière 2
  (3, 2, 'RI-G1', '2025/2026', 'S1', 25),
  (4, 2, 'RI-G2', '2025/2026', 'S1', 5),
  -- Filière 3
  (5, 3, 'MI-G1', '2025/2026', 'S1', 25),
  (6, 3, 'MI-G2', '2025/2026', 'S1', 5),
  -- Filière 4
  (7, 4, 'DG-G1', '2025/2026', 'S1', 25),
  (8, 4, 'DG-G2', '2025/2026', 'S1', 5),
  -- Filière 5
  (9, 5, 'GE-G1', '2025/2026', 'S1', 25),
  (10,5, 'GE-G2', '2025/2026', 'S1', 5),
  -- Filière 6
  (11,6, 'MD-G1', '2025/2026', 'S1', 25),
  (12,6, 'MD-G2', '2025/2026', 'S1', 5),
  -- Filière 7
  (13,7, 'EI-G1', '2025/2026', 'S1', 25),
  (14,7, 'EI-G2', '2025/2026', 'S1', 5),
  -- Filière 8
  (15,8, 'IA-G1', '2025/2026', 'S1', 25),
  (16,8, 'IA-G2', '2025/2026', 'S1', 5),
  -- Filière 9
  (17,9, 'SI-G1', '2025/2026', 'S1', 25),
  (18,9, 'SI-G2', '2025/2026', 'S1', 5),
  -- Filière 10
  (19,10,'CC-G1', '2025/2026', 'S1', 25),
  (20,10,'CC-G2', '2025/2026', 'S1', 5);

-- =============================
-- 5) Modules (30)
-- -----------------------------
INSERT INTO modules (module_id, admin_id, nom_module, volume_horaire) VALUES
  (1, 1, 'Algorithmes & POO', 60),
  (2, 1, 'HTML/CSS', 40),
  (3, 1, 'JavaScript', 50),
  (4, 1, 'PHP & MySQL', 70),
  (5, 1, 'Laravel', 60),
  (6, 1, 'Python', 70),
  (7, 1, 'Django', 50),
  (8, 1, 'Java', 60),
  (9, 1, 'Spring Boot', 60),
  (10,1, 'Android', 60),
  (11,1, 'iOS Swift', 60),
  (12,1, 'Data Structures', 60),
  (13,1, 'SQL Avancé', 40),
  (14,1, 'NoSQL', 40),
  (15,1, 'DevOps', 50),
  (16,1, 'Docker & Kubernetes', 50),
  (17,1, 'Linux', 40),
  (18,1, 'Réseaux', 40),
  (19,1, 'Sécurité', 50),
  (20,1, 'Machine Learning', 60),
  (21,1, 'Deep Learning', 60),
  (22,1, 'Big Data', 60),
  (23,1, 'Cloud AWS', 50),
  (24,1, 'Cloud Azure', 50),
  (25,1, 'Git & GitHub', 30),
  (26,1, 'UX/UI', 40),
  (27,1, 'Marketing Digital', 50),
  (28,1, 'Comptabilité', 40),
  (29,1, 'Gestion de Projet', 40),
  (30,1, 'Anglais Technique', 30);

-- =============================
-- 6) Salles (20 : 14 cours, 4 info, 1 dév numérique, 1 labo)
-- -----------------------------
INSERT INTO salles (salle_id, admin_id, code_salle, capacite) VALUES
  -- 14 salles de cours classiques
  (1, 1, 'C-101', 30),
  (2, 1, 'C-102', 30),
  (3, 1, 'C-103', 30),
  (4, 1, 'C-104', 30),
  (5, 1, 'C-105', 30),
  (6, 1, 'C-106', 30),
  (7, 1, 'C-107', 30),
  (8, 1, 'C-108', 30),
  (9, 1, 'C-109', 30),
  (10,1, 'C-110', 30),
  (11,1, 'C-111', 30),
  (12,1, 'C-112', 30),
  (13,1, 'C-113', 30),
  (14,1, 'C-114', 30),
  -- 4 salles informatiques
  (15,1, 'INF-201', 28),
  (16,1, 'INF-202', 28),
  (17,1, 'INF-203', 28),
  (18,1, 'INF-204', 28),
  -- 1 salle Dév.Numérique
  (19,1, 'DD-301', 25),
  -- 1 laboratoire
  (20,1, 'LAB-401', 20);

-- =============================
-- 7) Stagiaires (300)
-- -----------------------------
-- Générés en suivant la règle : 30 stagiaires par filière (25+5)
-- Boucle manuelle simplifiée pour l'exemple

INSERT INTO stagiaires (stagiaire_id, admin_id, groupe_id, id_inscription, cne, nom, prenom, telephone, date_naissance, sexe, adresse) VALUES
(1, 1, 1, 'STAG001', 'CNE001', 'Cherkaoui', 'Karim', '0617143421', '2004-07-20', 'F', 'Casablanca'),
(2, 1, 1, 'STAG002', 'CNE002', 'Zouaoui', 'Aya', '0617901609', '2003-09-06', 'M', 'Khénifra'),
(3, 1, 1, 'STAG003', 'CNE003', 'Zouaoui', 'Sara', '0615383360', '2004-02-23', 'F', 'Fès'),
(4, 1, 1, 'STAG004', 'CNE004', 'Boukhris', 'Karim', '0611784137', '2004-11-07', 'F', 'Khénifra'),
(5, 1, 1, 'STAG005', 'CNE005', 'Ait', 'Ali', '0611346932', '2005-02-11', 'F', 'Fès'),
(6, 1, 1, 'STAG006', 'CNE006', 'Ait', 'Ali', '0612564613', '2004-12-29', 'M', 'Meknès'),
(7, 1, 1, 'STAG007', 'CNE007', 'El', 'Sara', '0617193574', '2005-04-26', 'M', 'Rabat'),
(8, 1, 1, 'STAG008', 'CNE008', 'El Alaoui', 'Rania', '0614129436', '2003-11-03', 'F', 'Meknès'),
(9, 1, 1, 'STAG009', 'CNE009', 'Rifi', 'Rania', '0617057303', '2005-09-17', 'M', 'Fès'),
(10, 1, 1, 'STAG010', 'CNE010', 'El Alaoui', 'Aya', '0618561653', '2005-04-25', 'M', 'Meknès'),
(11, 1, 1, 'STAG011', 'CNE011', 'Rifi', 'Karim', '0613637157', '2005-01-30', 'M', 'Meknès'),
(12, 1, 1, 'STAG012', 'CNE012', 'Ait', 'Yassine', '0619868550', '2004-07-30', 'M', 'Fès'),
(13, 1, 1, 'STAG013', 'CNE013', 'Fadili', 'Aya', '0616653785', '2003-03-22', 'F', 'Casablanca'),
(14, 1, 1, 'STAG014', 'CNE014', 'Rifi', 'Salma', '0619579113', '2003-12-08', 'M', 'Rabat'),
(15, 1, 1, 'STAG015', 'CNE015', 'Zouaoui', 'Nabil', '0616781173', '2003-06-17', 'F', 'Casablanca'),
(16, 1, 1, 'STAG016', 'CNE016', 'El', 'Omar', '0613578797', '2005-08-15', 'F', 'Fès'),
(17, 1, 1, 'STAG017', 'CNE017', 'Cherkaoui', 'Ali', '0614352981', '2005-08-03', 'M', 'Fès'),
(18, 1, 1, 'STAG018', 'CNE018', 'Ait', 'Ali', '0613926757', '2005-02-22', 'F', 'Khénifra'),
(19, 1, 1, 'STAG019', 'CNE019', 'Ben', 'Ali', '0618253746', '2003-10-04', 'F', 'Casablanca'),
(20, 1, 1, 'STAG020', 'CNE020', 'Ben', 'Aya', '0615715151', '2004-04-24', 'M', 'Fès'),
(21, 1, 1, 'STAG021', 'CNE021', 'Ait', 'Omar', '0611684402', '2003-05-29', 'F', 'Casablanca'),
(22, 1, 1, 'STAG022', 'CNE022', 'El', 'Sara', '0616861252', '2004-12-08', 'M', 'Khénifra'),
(23, 1, 1, 'STAG023', 'CNE023', 'Zouaoui', 'Ali', '0618675117', '2004-08-05', 'F', 'Casablanca'),
(24, 1, 1, 'STAG024', 'CNE024', 'El Alaoui', 'Salma', '0618695537', '2004-09-08', 'M', 'Khénifra'),
(25, 1, 1, 'STAG025', 'CNE025', 'El Alaoui', 'Rania', '0617700141', '2004-08-25', 'F', 'Meknès'),
(26, 1, 2, 'STAG026', 'CNE026', 'Ait', 'Sara', '0613462030', '2004-05-19', 'M', 'Fès'),
(27, 1, 2, 'STAG027', 'CNE027', 'Zouaoui', 'Ali', '0617929398', '2003-01-08', 'M', 'Meknès'),
(28, 1, 2, 'STAG028', 'CNE028', 'Hajji', 'Karim', '0612269050', '2003-12-01', 'M', 'Khénifra'),
(29, 1, 2, 'STAG029', 'CNE029', 'Boukhris', 'Yassine', '0614851494', '2003-03-29', 'M', 'Casablanca'),
(30, 1, 2, 'STAG030', 'CNE030', 'Ait', 'Ali', '0613505157', '2003-11-26', 'M', 'Fès'),
(31, 1, 3, 'STAG031', 'CNE031', 'El Alaoui', 'Salma', '0613852027', '2003-02-04', 'F', 'Khénifra'),
(32, 1, 3, 'STAG032', 'CNE032', 'Ait', 'Yassine', '0613136121', '2004-01-24', 'F', 'Meknès'),
(33, 1, 3, 'STAG033', 'CNE033', 'Cherkaoui', 'Sara', '0614524001', '2005-04-29', 'M', 'Fès'),
(34, 1, 3, 'STAG034', 'CNE034', 'Ait', 'Aya', '0619971076', '2004-04-23', 'M', 'Rabat'),
(35, 1, 3, 'STAG035', 'CNE035', 'Hajji', 'Aya', '0616692638', '2003-12-25', 'F', 'Casablanca'),
(36, 1, 3, 'STAG036', 'CNE036', 'El', 'Karim', '0612191201', '2003-10-31', 'M', 'Rabat'),
(37, 1, 3, 'STAG037', 'CNE037', 'El', 'Yassine', '0614061847', '2003-10-05', 'M', 'Rabat'),
(38, 1, 3, 'STAG038', 'CNE038', 'Zouaoui', 'Sofia', '0618974915', '2003-12-05', 'M', 'Meknès'),
(39, 1, 3, 'STAG039', 'CNE039', 'Cherkaoui', 'Yassine', '0612564707', '2005-08-04', 'M', 'Meknès'),
(40, 1, 3, 'STAG040', 'CNE040', 'El', 'Aya', '0618662937', '2003-07-01', 'M', 'Meknès'),
(41, 1, 3, 'STAG041', 'CNE041', 'Fadili', 'Ali', '0617355343', '2004-09-20', 'M', 'Meknès'),
(42, 1, 3, 'STAG042', 'CNE042', 'Ait', 'Aya', '0612426687', '2004-01-08', 'M', 'Khénifra'),
(43, 1, 3, 'STAG043', 'CNE043', 'Ben', 'Yassine', '0617604821', '2003-12-24', 'M', 'Khénifra'),
(44, 1, 3, 'STAG044', 'CNE044', 'Boukhris', 'Yassine', '0613337178', '2003-03-13', 'F', 'Rabat'),
(45, 1, 3, 'STAG045', 'CNE045', 'El Alaoui', 'Ali', '0619994381', '2004-02-17', 'F', 'Fès'),
(46, 1, 3, 'STAG046', 'CNE046', 'Cherkaoui', 'Nabil', '0616047734', '2004-11-06', 'M', 'Meknès'),
(47, 1, 3, 'STAG047', 'CNE047', 'Hajji', 'Karim', '0613630989', '2003-06-30', 'F', 'Khénifra'),
(48, 1, 3, 'STAG048', 'CNE048', 'Ait', 'Aya', '0616409854', '2003-02-25', 'M', 'Rabat'),
(49, 1, 3, 'STAG049', 'CNE049', 'Ben', 'Karim', '0617408676', '2005-07-27', 'F', 'Meknès'),
(50, 1, 3, 'STAG050', 'CNE050', 'El', 'Sofia', '0612698902', '2003-09-06', 'F', 'Rabat'),
(51, 1, 3, 'STAG051', 'CNE051', 'Ait', 'Ali', '0617928940', '2004-07-30', 'F', 'Fès'),
(52, 1, 3, 'STAG052', 'CNE052', 'Fadili', 'Ali', '0615142652', '2005-02-16', 'M', 'Meknès'),
(53, 1, 3, 'STAG053', 'CNE053', 'Hajji', 'Salma', '0614788982', '2004-05-31', 'F', 'Casablanca'),
(54, 1, 3, 'STAG054', 'CNE054', 'Cherkaoui', 'Sara', '0617420161', '2004-03-26', 'M', 'Rabat'),
(55, 1, 3, 'STAG055', 'CNE055', 'Boukhris', 'Rania', '0614963832', '2004-10-19', 'M', 'Rabat'),
(56, 1, 4, 'STAG056', 'CNE056', 'Hajji', 'Karim', '0613112676', '2004-06-12', 'F', 'Fès'),
(57, 1, 4, 'STAG057', 'CNE057', 'Boukhris', 'Karim', '0612402317', '2004-10-24', 'F', 'Meknès'),
(58, 1, 4, 'STAG058', 'CNE058', 'El Alaoui', 'Karim', '0617309754', '2005-04-02', 'M', 'Meknès'),
(59, 1, 4, 'STAG059', 'CNE059', 'El Alaoui', 'Salma', '0617689816', '2005-02-03', 'F', 'Khénifra'),
(60, 1, 4, 'STAG060', 'CNE060', 'El', 'Aya', '0618201557', '2003-05-27', 'F', 'Fès'),
(61, 1, 5, 'STAG061', 'CNE061', 'Boukhris', 'Salma', '0615825077', '2004-10-02', 'F', 'Rabat'),
(62, 1, 5, 'STAG062', 'CNE062', 'Zouaoui', 'Nabil', '0619568354', '2003-07-22', 'F', 'Fès'),
(63, 1, 5, 'STAG063', 'CNE063', 'Fadili', 'Karim', '0618444608', '2004-12-23', 'F', 'Meknès'),
(64, 1, 5, 'STAG064', 'CNE064', 'Hajji', 'Ali', '0619886914', '2005-09-19', 'M', 'Casablanca'),
(65, 1, 5, 'STAG065', 'CNE065', 'Zouaoui', 'Omar', '0614622967', '2003-09-08', 'M', 'Fès'),
(66, 1, 5, 'STAG066', 'CNE066', 'Hajji', 'Rania', '0618337764', '2005-08-16', 'M', 'Casablanca'),
(67, 1, 5, 'STAG067', 'CNE067', 'Boukhris', 'Rania', '0613721643', '2003-11-15', 'M', 'Rabat'),
(68, 1, 5, 'STAG068', 'CNE068', 'Ben', 'Sofia', '0611860733', '2005-09-12', 'F', 'Meknès'),
(69, 1, 5, 'STAG069', 'CNE069', 'Ait', 'Ali', '0619185575', '2003-02-10', 'F', 'Meknès'),
(70, 1, 5, 'STAG070', 'CNE070', 'Ait', 'Ali', '0611356073', '2003-11-28', 'M', 'Casablanca'),
(71, 1, 5, 'STAG071', 'CNE071', 'Ben', 'Sofia', '0616605746', '2003-04-18', 'F', 'Casablanca'),
(72, 1, 5, 'STAG072', 'CNE072', 'Rifi', 'Karim', '0611966612', '2003-08-11', 'F', 'Meknès'),
(73, 1, 5, 'STAG073', 'CNE073', 'El Alaoui', 'Aya', '0616447085', '2005-04-02', 'M', 'Casablanca'),
(74, 1, 5, 'STAG074', 'CNE074', 'Fadili', 'Rania', '0618915025', '2003-05-22', 'F', 'Fès'),
(75, 1, 5, 'STAG075', 'CNE075', 'El Alaoui', 'Yassine', '0617559413', '2005-06-22', 'F', 'Fès'),
(76, 1, 5, 'STAG076', 'CNE076', 'Ben', 'Salma', '0611991337', '2005-07-30', 'F', 'Khénifra'),
(77, 1, 5, 'STAG077', 'CNE077', 'Hajji', 'Salma', '0614318291', '2004-09-01', 'M', 'Fès'),
(78, 1, 5, 'STAG078', 'CNE078', 'Hajji', 'Salma', '0616037602', '2005-09-24', 'F', 'Casablanca'),
(79, 1, 5, 'STAG079', 'CNE079', 'Ait', 'Rania', '0618582789', '2003-12-08', 'F', 'Fès'),
(80, 1, 5, 'STAG080', 'CNE080', 'Boukhris', 'Sara', '0618954996', '2005-07-08', 'F', 'Meknès'),
(81, 1, 5, 'STAG081', 'CNE081', 'Ben', 'Karim', '0611839802', '2003-08-30', 'F', 'Rabat'),
(82, 1, 5, 'STAG082', 'CNE082', 'Ben', 'Yassine', '0611595711', '2005-02-16', 'M', 'Rabat'),
(83, 1, 5, 'STAG083', 'CNE083', 'Ait', 'Rania', '0617804036', '2005-07-08', 'F', 'Casablanca'),
(84, 1, 5, 'STAG084', 'CNE084', 'El', 'Nabil', '0612017305', '2005-09-06', 'F', 'Khénifra'),
(85, 1, 5, 'STAG085', 'CNE085', 'Ait', 'Nabil', '0611331109', '2004-03-03', 'M', 'Fès'),
(86, 1, 6, 'STAG086', 'CNE086', 'Boukhris', 'Aya', '0617264432', '2003-10-16', 'M', 'Meknès'),
(87, 1, 6, 'STAG087', 'CNE087', 'Rifi', 'Ali', '0614792165', '2003-02-20', 'M', 'Fès'),
(88, 1, 6, 'STAG088', 'CNE088', 'Cherkaoui', 'Sofia', '0616101306', '2004-08-05', 'F', 'Casablanca'),
(89, 1, 6, 'STAG089', 'CNE089', 'El', 'Omar', '0612637432', '2005-08-01', 'F', 'Khénifra'),
(90, 1, 6, 'STAG090', 'CNE090', 'Ait', 'Yassine', '0612708124', '2004-04-20', 'F', 'Casablanca'),
(91, 1, 7, 'STAG091', 'CNE091', 'Ben', 'Sara', '0618132601', '2003-07-21', 'M', 'Fès'),
(92, 1, 7, 'STAG092', 'CNE092', 'Fadili', 'Nabil', '0616189472', '2004-12-31', 'M', 'Rabat'),
(93, 1, 7, 'STAG093', 'CNE093', 'Rifi', 'Yassine', '0612872262', '2003-04-11', 'M', 'Casablanca'),
(94, 1, 7, 'STAG094', 'CNE094', 'El Alaoui', 'Omar', '0614522594', '2003-12-23', 'M', 'Casablanca'),
(95, 1, 7, 'STAG095', 'CNE095', 'Zouaoui', 'Ali', '0612532181', '2003-01-08', 'M', 'Khénifra'),
(96, 1, 7, 'STAG096', 'CNE096', 'El', 'Sara', '0619587661', '2003-07-18', 'F', 'Khénifra'),
(97, 1, 7, 'STAG097', 'CNE097', 'Rifi', 'Sara', '0618402390', '2005-02-12', 'F', 'Meknès'),
(98, 1, 7, 'STAG098', 'CNE098', 'El Alaoui', 'Rania', '0614670780', '2005-02-07', 'M', 'Fès'),
(99, 1, 7, 'STAG099', 'CNE099', 'Ait', 'Yassine', '0611339845', '2003-03-29', 'F', 'Fès'),
(100, 1, 7, 'STAG100', 'CNE100', 'El', 'Karim', '0612377968', '2004-10-03', 'M', 'Fès'),
(101, 1, 7, 'STAG101', 'CNE101', 'Rifi', 'Karim', '0619814516', '2004-12-05', 'F', 'Fès'),
(102, 1, 7, 'STAG102', 'CNE102', 'Rifi', 'Salma', '0612223245', '2003-12-21', 'F', 'Rabat'),
(103, 1, 7, 'STAG103', 'CNE103', 'Zouaoui', 'Sofia', '0614528937', '2003-10-14', 'M', 'Casablanca'),
(104, 1, 7, 'STAG104', 'CNE104', 'El Alaoui', 'Nabil', '0615728558', '2005-03-11', 'M', 'Casablanca'),
(105, 1, 7, 'STAG105', 'CNE105', 'Zouaoui', 'Karim', '0612369641', '2005-05-07', 'M', 'Fès'),
(106, 1, 7, 'STAG106', 'CNE106', 'Ait', 'Karim', '0612665030', '2004-04-28', 'F', 'Meknès'),
(107, 1, 7, 'STAG107', 'CNE107', 'Fadili', 'Nabil', '0619991038', '2004-07-20', 'M', 'Meknès'),
(108, 1, 7, 'STAG108', 'CNE108', 'Zouaoui', 'Yassine', '0615655640', '2004-02-27', 'F', 'Casablanca'),
(109, 1, 7, 'STAG109', 'CNE109', 'Boukhris', 'Salma', '0613855609', '2003-06-05', 'M', 'Fès'),
(110, 1, 7, 'STAG110', 'CNE110', 'Ait', 'Ali', '0611359859', '2004-08-17', 'M', 'Khénifra'),
(111, 1, 7, 'STAG111', 'CNE111', 'Rifi', 'Sofia', '0619719361', '2004-02-15', 'F', 'Casablanca'),
(112, 1, 7, 'STAG112', 'CNE112', 'Boukhris', 'Karim', '0617995318', '2005-05-15', 'M', 'Khénifra'),
(113, 1, 7, 'STAG113', 'CNE113', 'Boukhris', 'Omar', '0611680107', '2005-01-24', 'F', 'Rabat'),
(114, 1, 7, 'STAG114', 'CNE114', 'El Alaoui', 'Sara', '0611134453', '2003-04-16', 'F', 'Fès'),
(115, 1, 7, 'STAG115', 'CNE115', 'El Alaoui', 'Salma', '0613432998', '2003-09-13', 'F', 'Fès'),
(116, 1, 8, 'STAG116', 'CNE116', 'Ben', 'Sara', '0612829312', '2003-10-08', 'F', 'Casablanca'),
(117, 1, 8, 'STAG117', 'CNE117', 'Boukhris', 'Ali', '0616793405', '2005-04-16', 'M', 'Fès'),
(118, 1, 8, 'STAG118', 'CNE118', 'El', 'Sara', '0617594954', '2005-01-02', 'F', 'Meknès'),
(119, 1, 8, 'STAG119', 'CNE119', 'Zouaoui', 'Rania', '0611417234', '2004-09-07', 'M', 'Meknès'),
(120, 1, 8, 'STAG120', 'CNE120', 'Rifi', 'Aya', '0616342215', '2005-02-24', 'M', 'Rabat'),
(121, 1, 9, 'STAG121', 'CNE121', 'Ben', 'Nabil', '0612492900', '2005-08-30', 'M', 'Meknès'),
(122, 1, 9, 'STAG122', 'CNE122', 'Hajji', 'Omar', '0612951211', '2004-10-08', 'F', 'Fès'),
(123, 1, 9, 'STAG123', 'CNE123', 'El', 'Rania', '0611070894', '2004-08-18', 'F', 'Khénifra'),
(124, 1, 9, 'STAG124', 'CNE124', 'Boukhris', 'Rania', '0618176038', '2003-09-16', 'M', 'Fès'),
(125, 1, 9, 'STAG125', 'CNE125', 'Cherkaoui', 'Nabil', '0611616757', '2003-12-29', 'M', 'Casablanca'),
(126, 1, 9, 'STAG126', 'CNE126', 'Hajji', 'Rania', '0612510494', '2003-01-19', 'F', 'Fès'),
(127, 1, 9, 'STAG127', 'CNE127', 'El', 'Nabil', '0613776364', '2005-07-24', 'F', 'Rabat'),
(128, 1, 9, 'STAG128', 'CNE128', 'El Alaoui', 'Karim', '0613324376', '2003-04-27', 'M', 'Casablanca'),
(129, 1, 9, 'STAG129', 'CNE129', 'Hajji', 'Sofia', '0614076424', '2005-05-12', 'F', 'Meknès'),
(130, 1, 9, 'STAG130', 'CNE130', 'El', 'Salma', '0613383617', '2003-09-10', 'F', 'Casablanca'),
(131, 1, 9, 'STAG131', 'CNE131', 'Ben', 'Aya', '0619562236', '2004-04-08', 'M', 'Rabat'),
(132, 1, 9, 'STAG132', 'CNE132', 'Boukhris', 'Aya', '0617738861', '2004-09-18', 'F', 'Fès'),
(133, 1, 9, 'STAG133', 'CNE133', 'Rifi', 'Karim', '0614578321', '2004-12-15', 'F', 'Rabat'),
(134, 1, 9, 'STAG134', 'CNE134', 'Ben', 'Aya', '0615437596', '2005-05-24', 'M', 'Rabat'),
(135, 1, 9, 'STAG135', 'CNE135', 'Hajji', 'Aya', '0613963530', '2003-09-13', 'F', 'Fès'),
(136, 1, 9, 'STAG136', 'CNE136', 'El Alaoui', 'Ali', '0617828051', '2004-06-19', 'F', 'Fès'),
(137, 1, 9, 'STAG137', 'CNE137', 'Ait', 'Karim', '0616972366', '2005-05-22', 'F', 'Meknès'),
(138, 1, 9, 'STAG138', 'CNE138', 'Zouaoui', 'Sofia', '0617022997', '2003-08-11', 'F', 'Meknès'),
(139, 1, 9, 'STAG139', 'CNE139', 'El', 'Rania', '0617502851', '2004-09-27', 'M', 'Khénifra'),
(140, 1, 9, 'STAG140', 'CNE140', 'Cherkaoui', 'Omar', '0613884545', '2003-12-26', 'M', 'Casablanca'),
(141, 1, 9, 'STAG141', 'CNE141', 'Fadili', 'Ali', '0616821263', '2005-08-28', 'F', 'Casablanca'),
(142, 1, 9, 'STAG142', 'CNE142', 'Boukhris', 'Yassine', '0618019126', '2003-04-16', 'F', 'Meknès'),
(143, 1, 9, 'STAG143', 'CNE143', 'El', 'Rania', '0614302223', '2003-05-06', 'M', 'Meknès'),
(144, 1, 9, 'STAG144', 'CNE144', 'Boukhris', 'Nabil', '0615420126', '2005-01-11', 'F', 'Rabat'),
(145, 1, 9, 'STAG145', 'CNE145', 'Boukhris', 'Sara', '0614948603', '2003-03-03', 'F', 'Fès'),
(146, 1, 10, 'STAG146', 'CNE146', 'El Alaoui', 'Rania', '0616475979', '2005-05-27', 'M', 'Meknès'),
(147, 1, 10, 'STAG147', 'CNE147', 'Rifi', 'Nabil', '0612464425', '2003-06-30', 'M', 'Rabat'),
(148, 1, 10, 'STAG148', 'CNE148', 'Hajji', 'Omar', '0611978855', '2005-05-04', 'M', 'Casablanca'),
(149, 1, 10, 'STAG149', 'CNE149', 'Zouaoui', 'Sara', '0619040993', '2004-09-15', 'M', 'Meknès'),
(150, 1, 10, 'STAG150', 'CNE150', 'Fadili', 'Nabil', '0618103003', '2005-07-01', 'F', 'Rabat'),
(151, 1, 11, 'STAG151', 'CNE151', 'Cherkaoui', 'Rania', '0612312485', '2004-03-06', 'F', 'Fès'),
(152, 1, 11, 'STAG152', 'CNE152', 'Ben', 'Sofia', '0614171390', '2005-04-04', 'F', 'Casablanca'),
(153, 1, 11, 'STAG153', 'CNE153', 'Ait', 'Rania', '0612461312', '2003-10-28', 'M', 'Casablanca'),
(154, 1, 11, 'STAG154', 'CNE154', 'El Alaoui', 'Ali', '0619200981', '2005-04-06', 'M', 'Fès'),
(155, 1, 11, 'STAG155', 'CNE155', 'Zouaoui', 'Rania', '0616902686', '2003-04-04', 'M', 'Rabat'),
(156, 1, 11, 'STAG156', 'CNE156', 'Ben', 'Salma', '0612327403', '2003-10-18', 'M', 'Meknès'),
(157, 1, 11, 'STAG157', 'CNE157', 'El Alaoui', 'Yassine', '0613510135', '2004-02-22', 'F', 'Khénifra'),
(158, 1, 11, 'STAG158', 'CNE158', 'Ben', 'Sara', '0617068554', '2003-03-01', 'F', 'Fès'),
(159, 1, 11, 'STAG159', 'CNE159', 'Hajji', 'Rania', '0614068592', '2005-08-11', 'M', 'Khénifra'),
(160, 1, 11, 'STAG160', 'CNE160', 'El Alaoui', 'Nabil', '0615925884', '2005-08-24', 'M', 'Meknès'),
(161, 1, 11, 'STAG161', 'CNE161', 'El', 'Sara', '0614596722', '2003-08-21', 'F', 'Casablanca'),
(162, 1, 11, 'STAG162', 'CNE162', 'Boukhris', 'Yassine', '0611024334', '2003-03-31', 'F', 'Casablanca'),
(163, 1, 11, 'STAG163', 'CNE163', 'Boukhris', 'Salma', '0619784304', '2005-03-23', 'M', 'Khénifra'),
(164, 1, 11, 'STAG164', 'CNE164', 'El', 'Aya', '0613809473', '2004-07-25', 'F', 'Khénifra'),
(165, 1, 11, 'STAG165', 'CNE165', 'Cherkaoui', 'Aya', '0617627633', '2005-08-29', 'M', 'Casablanca'),
(166, 1, 11, 'STAG166', 'CNE166', 'Hajji', 'Karim', '0619392477', '2005-07-29', 'M', 'Casablanca'),
(167, 1, 11, 'STAG167', 'CNE167', 'Boukhris', 'Omar', '0613777550', '2005-03-23', 'F', 'Casablanca'),
(168, 1, 11, 'STAG168', 'CNE168', 'Fadili', 'Salma', '0618994417', '2003-12-30', 'M', 'Casablanca'),
(169, 1, 11, 'STAG169', 'CNE169', 'El Alaoui', 'Sofia', '0612648809', '2005-05-03', 'M', 'Meknès'),
(170, 1, 11, 'STAG170', 'CNE170', 'Boukhris', 'Karim', '0617202405', '2005-02-13', 'M', 'Fès'),
(171, 1, 11, 'STAG171', 'CNE171', 'Zouaoui', 'Sara', '0613898872', '2004-11-27', 'F', 'Khénifra'),
(172, 1, 11, 'STAG172', 'CNE172', 'Cherkaoui', 'Omar', '0619474603', '2003-12-10', 'M', 'Rabat'),
(173, 1, 11, 'STAG173', 'CNE173', 'Rifi', 'Yassine', '0618696065', '2005-09-08', 'F', 'Khénifra'),
(174, 1, 11, 'STAG174', 'CNE174', 'Ait', 'Nabil', '0618857766', '2005-04-13', 'M', 'Khénifra'),
(175, 1, 11, 'STAG175', 'CNE175', 'Rifi', 'Omar', '0613559887', '2003-01-30', 'F', 'Meknès'),
(176, 1, 12, 'STAG176', 'CNE176', 'El Alaoui', 'Omar', '0619387303', '2003-02-11', 'M', 'Khénifra'),
(177, 1, 12, 'STAG177', 'CNE177', 'Ben', 'Sara', '0618838385', '2003-11-11', 'M', 'Khénifra'),
(178, 1, 12, 'STAG178', 'CNE178', 'Rifi', 'Rania', '0616861005', '2004-12-13', 'F', 'Fès'),
(179, 1, 12, 'STAG179', 'CNE179', 'Zouaoui', 'Aya', '0618392573', '2003-05-31', 'M', 'Meknès'),
(180, 1, 12, 'STAG180', 'CNE180', 'El', 'Aya', '0618899968', '2004-02-06', 'F', 'Fès'),
(181, 1, 13, 'STAG181', 'CNE181', 'Fadili', 'Salma', '0619386839', '2005-01-13', 'F', 'Rabat'),
(182, 1, 13, 'STAG182', 'CNE182', 'Ben', 'Nabil', '0612681680', '2003-05-23', 'M', 'Casablanca'),
(183, 1, 13, 'STAG183', 'CNE183', 'El Alaoui', 'Yassine', '0611841695', '2003-08-16', 'M', 'Casablanca'),
(184, 1, 13, 'STAG184', 'CNE184', 'Rifi', 'Yassine', '0617846089', '2003-05-04', 'M', 'Casablanca'),
(185, 1, 13, 'STAG185', 'CNE185', 'Ait', 'Karim', '0616468298', '2004-03-14', 'F', 'Rabat'),
(186, 1, 13, 'STAG186', 'CNE186', 'Cherkaoui', 'Karim', '0611181948', '2003-11-05', 'M', 'Casablanca'),
(187, 1, 13, 'STAG187', 'CNE187', 'Ben', 'Ali', '0617753683', '2004-04-19', 'F', 'Rabat'),
(188, 1, 13, 'STAG188', 'CNE188', 'Cherkaoui', 'Nabil', '0612301648', '2003-11-15', 'M', 'Casablanca'),
(189, 1, 13, 'STAG189', 'CNE189', 'El', 'Ali', '0612660874', '2005-08-23', 'M', 'Khénifra'),
(190, 1, 13, 'STAG190', 'CNE190', 'Rifi', 'Sara', '0617370361', '2005-01-18', 'M', 'Fès'),
(191, 1, 13, 'STAG191', 'CNE191', 'Boukhris', 'Aya', '0614451317', '2004-05-11', 'F', 'Casablanca'),
(192, 1, 13, 'STAG192', 'CNE192', 'Boukhris', 'Yassine', '0613247615', '2003-11-03', 'F', 'Casablanca'),
(193, 1, 13, 'STAG193', 'CNE193', 'Fadili', 'Omar', '0616806106', '2004-07-29', 'F', 'Rabat'),
(194, 1, 13, 'STAG194', 'CNE194', 'Hajji', 'Salma', '0613631789', '2005-01-29', 'M', 'Casablanca'),
(195, 1, 13, 'STAG195', 'CNE195', 'Boukhris', 'Nabil', '0615482709', '2004-09-17', 'M', 'Casablanca'),
(196, 1, 13, 'STAG196', 'CNE196', 'Zouaoui', 'Salma', '0612378349', '2003-08-19', 'M', 'Meknès'),
(197, 1, 13, 'STAG197', 'CNE197', 'El Alaoui', 'Rania', '0613208377', '2005-03-20', 'M', 'Fès'),
(198, 1, 13, 'STAG198', 'CNE198', 'Ait', 'Omar', '0617659551', '2005-02-28', 'F', 'Fès'),
(199, 1, 13, 'STAG199', 'CNE199', 'Rifi', 'Sara', '0614499690', '2004-12-06', 'M', 'Rabat'),
(200, 1, 13, 'STAG200', 'CNE200', 'El Alaoui', 'Yassine', '0619802314', '2004-06-05', 'M', 'Khénifra'),
(201, 1, 13, 'STAG201', 'CNE201', 'Zouaoui', 'Sofia', '0618496380', '2004-06-25', 'M', 'Fès'),
(202, 1, 13, 'STAG202', 'CNE202', 'Cherkaoui', 'Sara', '0611158965', '2003-04-01', 'M', 'Khénifra'),
(203, 1, 13, 'STAG203', 'CNE203', 'Ait', 'Omar', '0615324624', '2003-03-02', 'M', 'Khénifra'),
(204, 1, 13, 'STAG204', 'CNE204', 'Fadili', 'Aya', '0612399123', '2004-02-18', 'F', 'Casablanca'),
(205, 1, 13, 'STAG205', 'CNE205', 'Cherkaoui', 'Ali', '0619136162', '2003-06-02', 'F', 'Casablanca'),
(206, 1, 14, 'STAG206', 'CNE206', 'Fadili', 'Sara', '0614401496', '2003-04-24', 'F', 'Meknès'),
(207, 1, 14, 'STAG207', 'CNE207', 'Rifi', 'Salma', '0616796237', '2004-08-06', 'M', 'Meknès'),
(208, 1, 14, 'STAG208', 'CNE208', 'Ben', 'Salma', '0615738074', '2005-05-16', 'M', 'Rabat'),
(209, 1, 14, 'STAG209', 'CNE209', 'El Alaoui', 'Ali', '0617891316', '2003-12-29', 'F', 'Khénifra'),
(210, 1, 14, 'STAG210', 'CNE210', 'Ben', 'Nabil', '0614659129', '2004-09-30', 'M', 'Casablanca'),
(211, 1, 15, 'STAG211', 'CNE211', 'El Alaoui', 'Salma', '0618193274', '2004-10-08', 'F', 'Khénifra'),
(212, 1, 15, 'STAG212', 'CNE212', 'El', 'Sara', '0613560014', '2004-01-06', 'M', 'Khénifra'),
(213, 1, 15, 'STAG213', 'CNE213', 'Cherkaoui', 'Yassine', '0611370936', '2003-01-04', 'F', 'Rabat'),
(214, 1, 15, 'STAG214', 'CNE214', 'Boukhris', 'Karim', '0617923651', '2004-09-27', 'M', 'Rabat'),
(215, 1, 15, 'STAG215', 'CNE215', 'Ben', 'Karim', '0614983387', '2004-07-29', 'F', 'Fès'),
(216, 1, 15, 'STAG216', 'CNE216', 'Rifi', 'Omar', '0617144823', '2004-01-14', 'F', 'Fès'),
(217, 1, 15, 'STAG217', 'CNE217', 'Cherkaoui', 'Sara', '0619397716', '2005-09-04', 'F', 'Meknès'),
(218, 1, 15, 'STAG218', 'CNE218', 'Hajji', 'Omar', '0617873837', '2004-06-12', 'F', 'Fès'),
(219, 1, 15, 'STAG219', 'CNE219', 'Hajji', 'Sofia', '0619222075', '2003-01-15', 'F', 'Fès'),
(220, 1, 15, 'STAG220', 'CNE220', 'Zouaoui', 'Aya', '0618520872', '2003-10-24', 'F', 'Rabat'),
(221, 1, 15, 'STAG221', 'CNE221', 'Cherkaoui', 'Rania', '0616836266', '2004-02-06', 'F', 'Rabat'),
(222, 1, 15, 'STAG222', 'CNE222', 'Ait', 'Salma', '0611728957', '2003-09-22', 'F', 'Fès'),
(223, 1, 15, 'STAG223', 'CNE223', 'Hajji', 'Aya', '0613891089', '2004-03-14', 'M', 'Fès'),
(224, 1, 15, 'STAG224', 'CNE224', 'El', 'Karim', '0612269547', '2003-08-30', 'F', 'Fès'),
(225, 1, 15, 'STAG225', 'CNE225', 'Fadili', 'Ali', '0612629652', '2005-02-21', 'M', 'Meknès'),
(226, 1, 15, 'STAG226', 'CNE226', 'Zouaoui', 'Sara', '0611967725', '2003-10-31', 'M', 'Fès'),
(227, 1, 15, 'STAG227', 'CNE227', 'Ait', 'Omar', '0614554096', '2005-04-21', 'F', 'Casablanca'),
(228, 1, 15, 'STAG228', 'CNE228', 'Ben', 'Rania', '0615312873', '2004-05-29', 'F', 'Khénifra'),
(229, 1, 15, 'STAG229', 'CNE229', 'Fadili', 'Nabil', '0619407611', '2003-09-11', 'M', 'Fès'),
(230, 1, 15, 'STAG230', 'CNE230', 'El', 'Nabil', '0619735657', '2004-07-27', 'M', 'Casablanca'),
(231, 1, 15, 'STAG231', 'CNE231', 'El', 'Nabil', '0618789038', '2003-04-27', 'F', 'Rabat'),
(232, 1, 15, 'STAG232', 'CNE232', 'Ait', 'Sofia', '0614775276', '2003-02-20', 'F', 'Casablanca'),
(233, 1, 15, 'STAG233', 'CNE233', 'El Alaoui', 'Salma', '0614343886', '2004-10-03', 'M', 'Khénifra'),
(234, 1, 15, 'STAG234', 'CNE234', 'Ait', 'Rania', '0616126207', '2004-01-27', 'F', 'Rabat'),
(235, 1, 15, 'STAG235', 'CNE235', 'Hajji', 'Nabil', '0614663444', '2003-07-24', 'F', 'Rabat'),
(236, 1, 16, 'STAG236', 'CNE236', 'El Alaoui', 'Sara', '0617216759', '2004-07-15', 'F', 'Fès'),
(237, 1, 16, 'STAG237', 'CNE237', 'Ait', 'Sara', '0619103090', '2005-08-27', 'M', 'Rabat'),
(238, 1, 16, 'STAG238', 'CNE238', 'Zouaoui', 'Aya', '0615594653', '2003-09-08', 'M', 'Rabat'),
(239, 1, 16, 'STAG239', 'CNE239', 'Boukhris', 'Ali', '0619557827', '2003-05-26', 'F', 'Casablanca'),
(240, 1, 16, 'STAG240', 'CNE240', 'Hajji', 'Ali', '0611550515', '2005-02-15', 'M', 'Meknès'),
(241, 1, 17, 'STAG241', 'CNE241', 'Ait', 'Sara', '0618035502', '2004-05-21', 'F', 'Casablanca'),
(242, 1, 17, 'STAG242', 'CNE242', 'Ait', 'Yassine', '0616887476', '2005-08-16', 'M', 'Meknès'),
(243, 1, 17, 'STAG243', 'CNE243', 'Hajji', 'Karim', '0616946765', '2003-02-12', 'F', 'Rabat'),
(244, 1, 17, 'STAG244', 'CNE244', 'Rifi', 'Karim', '0618273446', '2005-06-16', 'F', 'Casablanca'),
(245, 1, 17, 'STAG245', 'CNE245', 'Hajji', 'Rania', '0614833700', '2003-10-12', 'F', 'Fès'),
(246, 1, 17, 'STAG246', 'CNE246', 'Cherkaoui', 'Rania', '0617564088', '2003-06-26', 'F', 'Khénifra'),
(247, 1, 17, 'STAG247', 'CNE247', 'Ben', 'Nabil', '0613796976', '2004-07-23', 'M', 'Rabat'),
(248, 1, 17, 'STAG248', 'CNE248', 'Ben', 'Omar', '0617064986', '2003-12-15', 'M', 'Casablanca'),
(249, 1, 17, 'STAG249', 'CNE249', 'Zouaoui', 'Ali', '0619124193', '2004-12-29', 'F', 'Fès'),
(250, 1, 17, 'STAG250', 'CNE250', 'Hajji', 'Omar', '0615570261', '2004-06-23', 'F', 'Meknès'),
(251, 1, 17, 'STAG251', 'CNE251', 'Hajji', 'Yassine', '0618351319', '2005-08-12', 'F', 'Khénifra'),
(252, 1, 17, 'STAG252', 'CNE252', 'Cherkaoui', 'Sara', '0616359744', '2004-08-27', 'F', 'Rabat'),
(253, 1, 17, 'STAG253', 'CNE253', 'Hajji', 'Nabil', '0619476397', '2005-01-06', 'M', 'Meknès'),
(254, 1, 17, 'STAG254', 'CNE254', 'Fadili', 'Salma', '0617146584', '2003-07-28', 'M', 'Casablanca'),
(255, 1, 17, 'STAG255', 'CNE255', 'Cherkaoui', 'Sara', '0613906685', '2003-10-22', 'M', 'Meknès'),
(256, 1, 17, 'STAG256', 'CNE256', 'Boukhris', 'Aya', '0619263820', '2003-06-04', 'M', 'Casablanca'),
(257, 1, 17, 'STAG257', 'CNE257', 'El', 'Aya', '0614669643', '2003-02-19', 'F', 'Fès'),
(258, 1, 17, 'STAG258', 'CNE258', 'Rifi', 'Sofia', '0617088387', '2005-01-26', 'F', 'Casablanca'),
(259, 1, 17, 'STAG259', 'CNE259', 'Hajji', 'Karim', '0612446163', '2005-08-26', 'M', 'Meknès'),
(260, 1, 17, 'STAG260', 'CNE260', 'Boukhris', 'Sofia', '0614609725', '2003-09-14', 'F', 'Rabat'),
(261, 1, 17, 'STAG261', 'CNE261', 'El', 'Salma', '0612489797', '2004-09-27', 'F', 'Rabat'),
(262, 1, 17, 'STAG262', 'CNE262', 'Fadili', 'Nabil', '0614239444', '2003-12-23', 'M', 'Khénifra'),
(263, 1, 17, 'STAG263', 'CNE263', 'Ait', 'Rania', '0616995485', '2003-05-02', 'M', 'Khénifra'),
(264, 1, 17, 'STAG264', 'CNE264', 'Ben', 'Sofia', '0611744863', '2003-05-24', 'M', 'Khénifra'),
(265, 1, 17, 'STAG265', 'CNE265', 'Ben', 'Salma', '0614885859', '2004-09-15', 'F', 'Casablanca'),
(266, 1, 18, 'STAG266', 'CNE266', 'El Alaoui', 'Sara', '0616537813', '2004-07-25', 'F', 'Fès'),
(267, 1, 18, 'STAG267', 'CNE267', 'Fadili', 'Sara', '0618686085', '2003-11-19', 'M', 'Meknès'),
(268, 1, 18, 'STAG268', 'CNE268', 'Ait', 'Sara', '0616281940', '2003-10-21', 'M', 'Fès'),
(269, 1, 18, 'STAG269', 'CNE269', 'Ben', 'Ali', '0619165676', '2003-03-15', 'M', 'Rabat'),
(270, 1, 18, 'STAG270', 'CNE270', 'Cherkaoui', 'Yassine', '0612319278', '2003-01-31', 'F', 'Fès'),
(271, 1, 19, 'STAG271', 'CNE271', 'Boukhris', 'Ali', '0616039120', '2004-11-18', 'F', 'Fès'),
(272, 1, 19, 'STAG272', 'CNE272', 'Fadili', 'Rania', '0614675891', '2005-08-20', 'M', 'Fès'),
(273, 1, 19, 'STAG273', 'CNE273', 'Boukhris', 'Aya', '0612773693', '2003-08-23', 'F', 'Casablanca'),
(274, 1, 19, 'STAG274', 'CNE274', 'Boukhris', 'Nabil', '0611860648', '2004-01-22', 'F', 'Khénifra'),
(275, 1, 19, 'STAG275', 'CNE275', 'Ait', 'Yassine', '0615980990', '2005-03-29', 'M', 'Meknès'),
(276, 1, 19, 'STAG276', 'CNE276', 'Ben', 'Yassine', '0619062193', '2003-12-11', 'F', 'Khénifra'),
(277, 1, 19, 'STAG277', 'CNE277', 'Hajji', 'Yassine', '0614707397', '2004-01-09', 'F', 'Khénifra'),
(278, 1, 19, 'STAG278', 'CNE278', 'El Alaoui', 'Nabil', '0613845071', '2005-09-08', 'M', 'Meknès'),
(279, 1, 19, 'STAG279', 'CNE279', 'Ait', 'Sara', '0615744976', '2004-08-30', 'M', 'Fès'),
(280, 1, 19, 'STAG280', 'CNE280', 'El Alaoui', 'Sara', '0614767439', '2003-09-24', 'F', 'Meknès'),
(281, 1, 19, 'STAG281', 'CNE281', 'Cherkaoui', 'Ali', '0611390626', '2004-04-03', 'M', 'Fès'),
(282, 1, 19, 'STAG282', 'CNE282', 'Rifi', 'Rania', '0611395440', '2003-04-02', 'F', 'Casablanca'),
(283, 1, 19, 'STAG283', 'CNE283', 'Zouaoui', 'Yassine', '0615069615', '2004-07-28', 'F', 'Casablanca'),
(284, 1, 19, 'STAG284', 'CNE284', 'El Alaoui', 'Nabil', '0612084569', '2003-11-21', 'M', 'Rabat'),
(285, 1, 19, 'STAG285', 'CNE285', 'Ben', 'Sofia', '0612936581', '2003-01-26', 'M', 'Rabat'),
(286, 1, 19, 'STAG286', 'CNE286', 'Boukhris', 'Sara', '0616458105', '2004-10-03', 'F', 'Khénifra'),
(287, 1, 19, 'STAG287', 'CNE287', 'Ben', 'Ali', '0613931904', '2005-02-15', 'F', 'Meknès'),
(288, 1, 19, 'STAG288', 'CNE288', 'Hajji', 'Ali', '0617904226', '2004-10-03', 'F', 'Casablanca'),
(289, 1, 19, 'STAG289', 'CNE289', 'El', 'Salma', '0613928384', '2004-06-08', 'F', 'Rabat'),
(290, 1, 19, 'STAG290', 'CNE290', 'Hajji', 'Omar', '0618194599', '2005-05-21', 'M', 'Khénifra'),
(291, 1, 19, 'STAG291', 'CNE291', 'Boukhris', 'Ali', '0615011247', '2003-06-05', 'M', 'Khénifra'),
(292, 1, 19, 'STAG292', 'CNE292', 'Boukhris', 'Aya', '0615366694', '2005-04-18', 'M', 'Meknès'),
(293, 1, 19, 'STAG293', 'CNE293', 'Zouaoui', 'Yassine', '0614165696', '2004-07-13', 'M', 'Khénifra'),
(294, 1, 19, 'STAG294', 'CNE294', 'Cherkaoui', 'Omar', '0616818880', '2004-02-18', 'M', 'Fès'),
(295, 1, 19, 'STAG295', 'CNE295', 'El Alaoui', 'Rania', '0618525037', '2003-05-15', 'M', 'Meknès'),
(296, 1, 20, 'STAG296', 'CNE296', 'Ait', 'Ali', '0614871727', '2004-08-26', 'M', 'Rabat'),
(297, 1, 20, 'STAG297', 'CNE297', 'Rifi', 'Sofia', '0616248859', '2004-03-28', 'M', 'Casablanca'),
(298, 1, 20, 'STAG298', 'CNE298', 'El Alaoui', 'Karim', '0618724378', '2004-08-19', 'F', 'Fès'),
(299, 1, 20, 'STAG299', 'CNE299', 'Cherkaoui', 'Yassine', '0613477690', '2003-12-07', 'F', 'Rabat'),
(300, 1, 20, 'STAG300', 'CNE300', 'Zouaoui', 'Karim', '0611140162', '2003-07-27', 'F', 'Rabat');