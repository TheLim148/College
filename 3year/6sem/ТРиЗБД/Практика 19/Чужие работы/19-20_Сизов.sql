CREATE TABLE olympiad_all_2025 (
    municipality VARCHAR(100) NOT NULL,
    stage VARCHAR(10) NOT NULL,
    english_language INT DEFAULT 0,
    astronomy INT DEFAULT 0,
    biology INT DEFAULT 0,
    geography INT DEFAULT 0,
    computer_science INT DEFAULT 0,
    art INT DEFAULT 0,
    spanish_language INT DEFAULT 0,
    history INT DEFAULT 0,
    italian_language INT DEFAULT 0,
    chinese_language INT DEFAULT 0,
    literature INT DEFAULT 0,
    mathematics INT DEFAULT 0,
    german_language INT DEFAULT 0,
    social_studies INT DEFAULT 0,
    life_safety INT DEFAULT 0,
    law INT DEFAULT 0,
    russian_language INT DEFAULT 0,
    technology INT DEFAULT 0,
    physics INT DEFAULT 0,
    physical_education INT DEFAULT 0,
    french_language INT DEFAULT 0,
    chemistry INT DEFAULT 0,
    ecology INT DEFAULT 0,
    economics INT DEFAULT 0,
    struve_astronomy INT DEFAULT 0,    
    maxwell_physics INT DEFAULT 0,   
    euler_mathematics INT DEFAULT 0,     
    keldysh_computer_science INT DEFAULT 0, 
    PRIMARY KEY (municipality, stage)
);

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'ШЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    0, 0, 0, 0  
FROM olympiad_school_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'МЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    0, 0, 0, 0
FROM olympiad_municipal_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'РЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, 0, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
FROM olympiad_regional_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
)
SELECT
    municipality, 'ЗЭ',
    english_language, astronomy, biology, geography, computer_science,
    art, spanish_language, history, italian_language, chinese_language,
    literature, mathematics, german_language, social_studies,
    life_safety, law, russian_language, technology, physics,
    physical_education, french_language, chemistry, ecology, economics,
    struve_astronomy, maxwell_physics, euler_mathematics, keldysh_computer_science
FROM olympiad_final_2025;

INSERT INTO olympiad_all_2025 (
    municipality, stage,
    chemistry
)
SELECT
    municipality, 'Р',
    chemistry
FROM olympiad_results_2025;