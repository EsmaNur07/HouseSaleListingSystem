-- Ev Satış Listeleme Sistemi Veritabanı Oluşturma
CREATE DATABASE EvSatisListelemeSistemi;
GO

USE EvSatisListelemeSistemi;
GO

-- EV_SAHIBI tablosu
CREATE TABLE EV_SAHIBI (
    EV_SAHIBI_ID INT PRIMARY KEY IDENTITY(1,1),
    ISIM NVARCHAR(50) NOT NULL,
    SOYISIM NVARCHAR(50) NOT NULL,
    TELEFON NVARCHAR(15) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL
);

-- EV tablosu
CREATE TABLE EV (
    TAPU_NO NVARCHAR(20) PRIMARY KEY,
    FIYAT DECIMAL(15, 2) NOT NULL,
    ODA_SAYISI INT NOT NULL,
    METRE_KARE DECIMAL(10, 2) NOT NULL,
    KAT_SAYISI INT NOT NULL,
    KONUT_TIPI NVARCHAR(50) NOT NULL,
    YAPIM_YILI INT NOT NULL,
    DURUM NVARCHAR(20) NOT NULL,
    EV_SAHIBI_ID INT NOT NULL,
    FOREIGN KEY (EV_SAHIBI_ID) REFERENCES EV_SAHIBI(EV_SAHIBI_ID)
);

-- ADRES tablosu
CREATE TABLE ADRES (
    ADRES_ID INT PRIMARY KEY IDENTITY(1,1),
    TAPU_NO NVARCHAR(20) NOT NULL,
    IL NVARCHAR(50) NOT NULL,
    ILCE NVARCHAR(50) NOT NULL,
    MAHALLE NVARCHAR(100) NOT NULL,
    CADDE NVARCHAR(100),
    SOKAK NVARCHAR(100) NOT NULL,
    BINA_NO NVARCHAR(10) NOT NULL,
    DAIRE_NO NVARCHAR(10),
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO)
);

-- EMLAK_SIRKETI tablosu
CREATE TABLE EMLAK_SIRKETI (
    FIRMA_NO INT PRIMARY KEY IDENTITY(1,1),
    SIRKET_ADI NVARCHAR(100) NOT NULL,
    ADRES NVARCHAR(255) NOT NULL,
    TELEFON NVARCHAR(15) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL,
    WEB_SITESI NVARCHAR(100)
);

-- SATICI tablosu
CREATE TABLE SATICI (
    SATICI_ID INT PRIMARY KEY IDENTITY(1,1),
    ISIM NVARCHAR(50) NOT NULL,
    SOYISIM NVARCHAR(50) NOT NULL,
    TELEFON NVARCHAR(15) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL,
    FIRMA_NO INT,
    FOREIGN KEY (FIRMA_NO) REFERENCES EMLAK_SIRKETI(FIRMA_NO)
);

-- ALICI tablosu
CREATE TABLE ALICI (
    ALICI_ID INT PRIMARY KEY IDENTITY(1,1),
    ISIM NVARCHAR(50) NOT NULL,
    SOYISIM NVARCHAR(50) NOT NULL,
    TELEFON NVARCHAR(15) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL
);

-- SATIS tablosu
CREATE TABLE SATIS (
    SATIS_NO INT PRIMARY KEY IDENTITY(1,1),
    TAPU_NO NVARCHAR(20) NOT NULL,
    SATICI_ID INT NOT NULL,
    ALICI_ID INT NOT NULL,
    SATIS_TARIHI DATE NOT NULL,
    SATIS_FIYATI DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO),
    FOREIGN KEY (SATICI_ID) REFERENCES SATICI(SATICI_ID),
    FOREIGN KEY (ALICI_ID) REFERENCES ALICI(ALICI_ID)
);

-- ODEME tablosu
CREATE TABLE ODEME (
    ODEME_ID INT PRIMARY KEY IDENTITY(1,1),
    SATIS_NO INT NOT NULL,
    TUTAR DECIMAL(15, 2) NOT NULL,
    ODEME_TARIHI DATE NOT NULL,
    ODEME_YONTEMI NVARCHAR(50) NOT NULL,
    ONAY_DURUMU BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (SATIS_NO) REFERENCES SATIS(SATIS_NO)
);

-- SOZLESME tablosu
CREATE TABLE SOZLESME (
    SOZLESME_ID INT PRIMARY KEY IDENTITY(1,1),
    SATIS_NO INT NOT NULL,
    BELGE_URL NVARCHAR(255) NOT NULL,
    IMZALANMA_TARIHI DATE NOT NULL,
    FOREIGN KEY (SATIS_NO) REFERENCES SATIS(SATIS_NO)
);

-- EV_RESIMLERI tablosu
CREATE TABLE EV_RESIMLERI (
    RESIM_ID INT PRIMARY KEY IDENTITY(1,1),
    TAPU_NO NVARCHAR(20) NOT NULL,
    RESIM_URL NVARCHAR(255) NOT NULL,
    ACIKLAMA NVARCHAR(255),
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO)
);

-- KULLANICI_HESABI tablosu
CREATE TABLE KULLANICI_HESABI (
    KULLANICI_ID INT PRIMARY KEY IDENTITY(1,1),
    ISIM NVARCHAR(50) NOT NULL,
    SOYISIM NVARCHAR(50) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL,
    SIFRE NVARCHAR(100) NOT NULL,
    TELEFON NVARCHAR(15) NOT NULL,
    ONEREN_KULLANICI_ID INT,
    FOREIGN KEY (ONEREN_KULLANICI_ID) REFERENCES KULLANICI_HESABI(KULLANICI_ID)
);

-- DEGERLENDIRME tablosu
CREATE TABLE DEGERLENDIRME (
    DEGERLENDIRME_ID INT PRIMARY KEY IDENTITY(1,1),
    KULLANICI_ID INT NOT NULL,
    TAPU_NO NVARCHAR(20) NOT NULL,
    PUAN TINYINT NOT NULL,
    YORUM NVARCHAR(500),
    TARIH DATE NOT NULL,
    FOREIGN KEY (KULLANICI_ID) REFERENCES KULLANICI_HESABI(KULLANICI_ID),
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO),
    CONSTRAINT CHK_PUAN CHECK (PUAN BETWEEN 1 AND 5)
);

-- REZERVASYON tablosu
CREATE TABLE REZERVASYON (
    REZERVASYON_NO INT PRIMARY KEY IDENTITY(1,1),
    KULLANICI_ID INT NOT NULL,
    TAPU_NO NVARCHAR(20) NOT NULL,
    RANDEVU_ZAMANI DATETIME NOT NULL,
    DURUM NVARCHAR(20) NOT NULL,
    FOREIGN KEY (KULLANICI_ID) REFERENCES KULLANICI_HESABI(KULLANICI_ID),
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO)
);

-- SIGORTA_SIRKETI tablosu
CREATE TABLE SIGORTA_SIRKETI (
    SIRKET_ID INT PRIMARY KEY IDENTITY(1,1),
    SIRKET_ADI NVARCHAR(100) NOT NULL,
    ADRES NVARCHAR(255) NOT NULL,
    TELEFON NVARCHAR(15) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL,
    WEB_SITESI NVARCHAR(100)
);

-- SIGORTA tablosu
CREATE TABLE SIGORTA (
    POLICE_NO NVARCHAR(50) PRIMARY KEY,
    TAPU_NO NVARCHAR(20) NOT NULL,
    SIRKET_ID INT NOT NULL,
    BASLANGIC_TARIHI DATE NOT NULL,
    BITIS_TARIHI DATE NOT NULL,
    KAPSAM NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO),
    FOREIGN KEY (SIRKET_ID) REFERENCES SIGORTA_SIRKETI(SIRKET_ID)
);

-- ILAN tablosu
CREATE TABLE ILAN (
    ILAN_ID INT PRIMARY KEY IDENTITY(1,1),
    TAPU_NO NVARCHAR(20) NOT NULL,
    SATICI_ID INT NOT NULL,
    BASLIK NVARCHAR(100) NOT NULL,
    ACIKLAMA NVARCHAR(MAX) NOT NULL,
    YAYIN_TARIHI DATE NOT NULL,
    FIYAT DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO),
    FOREIGN KEY (SATICI_ID) REFERENCES SATICI(SATICI_ID)
);

-- FAVORILER tablosu (N:M ilişkisi için ara tablo)
CREATE TABLE FAVORILER (
    FAVORI_ID INT PRIMARY KEY IDENTITY(1,1),
    KULLANICI_ID INT NOT NULL,
    ILAN_ID INT NOT NULL,
    FOREIGN KEY (KULLANICI_ID) REFERENCES KULLANICI_HESABI(KULLANICI_ID),
    FOREIGN KEY (ILAN_ID) REFERENCES ILAN(ILAN_ID),
    CONSTRAINT UQ_FAVORI UNIQUE (KULLANICI_ID, ILAN_ID)
);

-- BILDIRIM tablosu
CREATE TABLE BILDIRIM (
    BILDIRIM_ID INT PRIMARY KEY IDENTITY(1,1),
    KULLANICI_ID INT NOT NULL,
    BASLIK NVARCHAR(100) NOT NULL,
    GONDERME_TARIHI DATETIME NOT NULL,
    BILDIRIM_TIPI NVARCHAR(50) NOT NULL,
    FOREIGN KEY (KULLANICI_ID) REFERENCES KULLANICI_HESABI(KULLANICI_ID)
);

-- VERGI tablosu
CREATE TABLE VERGI (
    VERGI_NO INT PRIMARY KEY IDENTITY(1,1),
    TAPU_NO NVARCHAR(20) NOT NULL,
    YIL INT NOT NULL,
    TUTAR DECIMAL(15, 2) NOT NULL,
    SON_ODEME_TARIHI DATE NOT NULL,
    ODEME_DURUMU BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (TAPU_NO) REFERENCES EV(TAPU_NO),
    CONSTRAINT UQ_VERGI_YIL UNIQUE (TAPU_NO, YIL)
);

-- Örnek veriler için INSERT komutları
-- EV_SAHIBI örnek veri
INSERT INTO EV_SAHIBI (ISIM, SOYISIM, TELEFON, EMAIL)
VALUES 
('Ahmet', 'Yılmaz', '05301234567', 'ahmet.yilmaz@email.com'),
('Ayşe', 'Demir', '05329876543', 'ayse.demir@email.com'),
('Mehmet', 'Kaya', '05367894561', 'mehmet.kaya@email.com');

-- EV örnek veri
INSERT INTO EV (TAPU_NO, FIYAT, ODA_SAYISI, METRE_KARE, KAT_SAYISI, KONUT_TIPI, YAPIM_YILI, DURUM, EV_SAHIBI_ID)
VALUES 
('TR12345678901', 1500000.00, 3, 120.50, 4, 'Daire', 2015, 'Satılık', 1),
('TR98765432109', 2300000.00, 4, 150.75, 5, 'Daire', 2018, 'Satılık', 2),
('TR45678901234', 3500000.00, 5, 200.00, 3, 'Müstakil', 2010, 'Satılık', 3);

-- ADRES örnek veri
INSERT INTO ADRES (TAPU_NO, IL, ILCE, MAHALLE, CADDE, SOKAK, BINA_NO, DAIRE_NO)
VALUES 
('TR12345678901', 'İstanbul', 'Kadıköy', 'Göztepe', 'Bağdat', 'Çınar', '12', '5'),
('TR98765432109', 'Ankara', 'Çankaya', 'Bahçelievler', 'Atatürk', 'Gül', '45', '10'),
('TR45678901234', 'İzmir', 'Karşıyaka', 'Bostanlı', 'Cumhuriyet', 'Deniz', '8', NULL);

-- EMLAK_SIRKETI örnek veri
INSERT INTO EMLAK_SIRKETI (SIRKET_ADI, ADRES, TELEFON, EMAIL, WEB_SITESI)
VALUES 
('Emlak Dünyası', 'İstanbul, Levent, İş Merkezi No:5', '02123456789', 'info@emlakdunyasi.com', 'www.emlakdunyasi.com'),
('Konut Avcısı', 'Ankara, Kızılay, Merkez Plaza Kat:3', '03124567890', 'bilgi@konutavcisi.com', 'www.konutavcisi.com');

-- SATICI örnek veri
INSERT INTO SATICI (ISIM, SOYISIM, TELEFON, EMAIL, FIRMA_NO)
VALUES 
('Ali', 'Yıldız', '05551234567', 'ali.yildiz@email.com', 1),
('Zeynep', 'Ak', '05552345678', 'zeynep.ak@email.com', 2),
('Hakan', 'Öz', '05553456789', 'hakan.oz@email.com', 1);

-- ALICI örnek veri
INSERT INTO ALICI (ISIM, SOYISIM, TELEFON, EMAIL)
VALUES 
('Selin', 'Çelik', '05421234567', 'selin.celik@email.com'),
('Emre', 'Güneş', '05432345678', 'emre.gunes@email.com'),
('Deniz', 'Aydın', '05443456789', 'deniz.aydin@email.com');

-- SATIS örnek veri (Sadece bir ev satıldı varsayalım)
INSERT INTO SATIS (TAPU_NO, SATICI_ID, ALICI_ID, SATIS_TARIHI, SATIS_FIYATI)
VALUES ('TR12345678901', 1, 1, '2023-08-15', 1450000.00);

-- ODEME örnek veri
INSERT INTO ODEME (SATIS_NO, TUTAR, ODEME_TARIHI, ODEME_YONTEMI, ONAY_DURUMU)
VALUES (1, 1450000.00, '2023-08-15', 'Banka Transferi', 1);

-- SOZLESME örnek veri
INSERT INTO SOZLESME (SATIS_NO, BELGE_URL, IMZALANMA_TARIHI)
VALUES (1, '/dosyalar/sozlesmeler/sozlesme_12345.pdf', '2023-08-15');

-- EV_RESIMLERI örnek veri
INSERT INTO EV_RESIMLERI (TAPU_NO, RESIM_URL, ACIKLAMA)
VALUES 
('TR12345678901', '/resimler/ev1_salon.jpg', 'Salon'),
('TR12345678901', '/resimler/ev1_mutfak.jpg', 'Mutfak'),
('TR98765432109', '/resimler/ev2_salon.jpg', 'Salon'),
('TR98765432109', '/resimler/ev2_balkon.jpg', 'Balkon'),
('TR45678901234', '/resimler/ev3_on.jpg', 'Ön Görünüm'),
('TR45678901234', '/resimler/ev3_bahce.jpg', 'Bahçe');

-- KULLANICI_HESABI örnek veri
INSERT INTO KULLANICI_HESABI (ISIM, SOYISIM, EMAIL, SIFRE, TELEFON, ONEREN_KULLANICI_ID)
VALUES 
('Cem', 'Yılmaz', 'cem.yilmaz@email.com', 'hashedpassword1', '05551112233', NULL),
('Buse', 'Kara', 'buse.kara@email.com', 'hashedpassword2', '05552223344', 1),
('Onur', 'Taş', 'onur.tas@email.com', 'hashedpassword3', '05553334455', NULL);

-- DEGERLENDIRME örnek veri
INSERT INTO DEGERLENDIRME (KULLANICI_ID, TAPU_NO, PUAN, YORUM, TARIH)
VALUES 
(1, 'TR98765432109', 5, 'Çok güzel bir ev, konumu harika.', '2023-07-10'),
(2, 'TR45678901234', 4, 'Bahçesi geniş ve ferah.', '2023-08-05');

-- REZERVASYON örnek veri
INSERT INTO REZERVASYON (KULLANICI_ID, TAPU_NO, RANDEVU_ZAMANI, DURUM)
VALUES 
(3, 'TR98765432109', '2023-08-20 14:30:00', 'Onaylandı'),
(2, 'TR45678901234', '2023-08-22 11:00:00', 'Beklemede');

-- SIGORTA_SIRKETI örnek veri
INSERT INTO SIGORTA_SIRKETI (SIRKET_ADI, ADRES, TELEFON, EMAIL, WEB_SITESI)
VALUES 
('Güven Sigorta', 'İstanbul, Maslak, Plaza No:10', '02129876543', 'info@guvensigorta.com', 'www.guvensigorta.com'),
('Emniyet Sigorta', 'Ankara, Ulus, İş Hanı No:5', '03129876543', 'iletisim@emniyetsigorta.com', 'www.emniyetsigorta.com');

-- SIGORTA örnek veri
INSERT INTO SIGORTA (POLICE_NO, TAPU_NO, SIRKET_ID, BASLANGIC_TARIHI, BITIS_TARIHI, KAPSAM)
VALUES 
('POL123456', 'TR12345678901', 1, '2023-01-01', '2024-01-01', 'Deprem, Yangın, Su Baskını'),
('POL789012', 'TR45678901234', 2, '2023-03-15', '2024-03-15', 'Deprem, Yangın, Hırsızlık');

-- ILAN örnek veri
INSERT INTO ILAN (TAPU_NO, SATICI_ID, BASLIK, ACIKLAMA, YAYIN_TARIHI, FIYAT)
VALUES 
('TR98765432109', 2, 'Çankayada Lüks Daire', 'Ankaranın en merkezi konumunda eşyalı manzaralı daire.', '2023-07-01', 2350000.00),
('TR45678901234', 3, 'İzmirde Bahçeli Müstakil Ev', 'Denize yakın geniş bahçeli yenilenmiş müstakil ev.', '2023-06-15', 3550000.00);

-- FAVORILER örnek veri
INSERT INTO FAVORILER (KULLANICI_ID, ILAN_ID)
VALUES 
(1, 1),
(2, 2),
(3, 1);

-- BILDIRIM örnek veri
INSERT INTO BILDIRIM (KULLANICI_ID, BASLIK, GONDERME_TARIHI, BILDIRIM_TIPI)
VALUES 
(1, 'Favori ilanınızda fiyat değişikliği', '2023-08-05 10:15:00', 'Fiyat Değişikliği'),
(2, 'Randevunuz onaylandı', '2023-08-18 09:30:00', 'Randevu'),
(3, 'Yeni ilanlara göz atın', '2023-08-10 14:00:00', 'Öneri');

-- VERGI örnek veri
INSERT INTO VERGI (TAPU_NO, YIL, TUTAR, SON_ODEME_TARIHI, ODEME_DURUMU)
VALUES 
('TR12345678901', 2023, 2500.00, '2023-11-30', 0),
('TR98765432109', 2023, 3200.00, '2023-11-30', 1),
('TR45678901234', 2023, 4500.00, '2023-11-30', 0);

-- İndeksler oluşturma (performans için)
CREATE INDEX IDX_EV_FIYAT ON EV(FIYAT);
CREATE INDEX IDX_EV_DURUM ON EV(DURUM);
CREATE INDEX IDX_ADRES_IL_ILCE ON ADRES(IL, ILCE);
CREATE INDEX IDX_ILAN_YAYIN_TARIHI ON ILAN(YAYIN_TARIHI);
CREATE INDEX IDX_SATIS_TARIHI ON SATIS(SATIS_TARIHI);

-- Özel İşlevler
-- 1. İl ve ilçeye göre satılık evleri listeleme stored procedure
CREATE PROCEDURE sp_IlIlceGoreSatilikEvler
    @il NVARCHAR(50),
    @ilce NVARCHAR(50) = NULL
AS
BEGIN
    SELECT e.TAPU_NO, e.FIYAT, e.ODA_SAYISI, e.METRE_KARE, e.KONUT_TIPI, 
           a.IL, a.ILCE, a.MAHALLE, a.SOKAK
    FROM EV e
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    INNER JOIN ILAN i ON e.TAPU_NO = i.TAPU_NO
    WHERE a.IL = @il
    AND (@ilce IS NULL OR a.ILCE = @ilce)
    AND e.DURUM = 'Satılık'
    ORDER BY e.FIYAT ASC;
END;

-- 2. Belirli kriterlere göre ev arama stored procedure
CREATE PROCEDURE sp_EvAra
    @minFiyat DECIMAL(15, 2) = NULL,
    @maxFiyat DECIMAL(15, 2) = NULL,
    @minOdaSayisi INT = NULL,
    @minMetreKare DECIMAL(10, 2) = NULL,
    @konutTipi NVARCHAR(50) = NULL,
    @il NVARCHAR(50) = NULL
AS
BEGIN
    SELECT e.TAPU_NO, e.FIYAT, e.ODA_SAYISI, e.METRE_KARE, e.KONUT_TIPI, e.YAPIM_YILI,
           a.IL, a.ILCE, a.MAHALLE, a.SOKAK
    FROM EV e
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    WHERE (@minFiyat IS NULL OR e.FIYAT >= @minFiyat)
    AND (@maxFiyat IS NULL OR e.FIYAT <= @maxFiyat)
    AND (@minOdaSayisi IS NULL OR e.ODA_SAYISI >= @minOdaSayisi)
    AND (@minMetreKare IS NULL OR e.METRE_KARE >= @minMetreKare)
    AND (@konutTipi IS NULL OR e.KONUT_TIPI = @konutTipi)
    AND (@il IS NULL OR a.IL = @il)
    AND e.DURUM = 'Satılık'
    ORDER BY e.FIYAT ASC;
END;

-- 3. Ev detaylarını gösteren view oluşturma
CREATE VIEW vw_EvDetaylari AS
SELECT e.TAPU_NO, e.FIYAT, e.ODA_SAYISI, e.METRE_KARE, e.KAT_SAYISI, e.KONUT_TIPI, e.YAPIM_YILI, e.DURUM,
       a.IL, a.ILCE, a.MAHALLE, a.CADDE, a.SOKAK, a.BINA_NO, a.DAIRE_NO,
       es.ISIM + ' ' + es.SOYISIM AS EV_SAHIBI,
       (SELECT COUNT(*) FROM EV_RESIMLERI WHERE TAPU_NO = e.TAPU_NO) AS RESIM_SAYISI,
       (SELECT AVG(CAST(PUAN AS FLOAT)) FROM DEGERLENDIRME WHERE TAPU_NO = e.TAPU_NO) AS ORTALAMA_PUAN
FROM EV e
INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
INNER JOIN EV_SAHIBI es ON e.EV_SAHIBI_ID = es.EV_SAHIBI_ID;

-- 4. Satış özeti view oluşturma
CREATE VIEW vw_SatisOzeti AS
SELECT s.SATIS_NO, s.SATIS_TARIHI, s.SATIS_FIYATI,
       e.TAPU_NO, e.ODA_SAYISI, e.METRE_KARE, e.KONUT_TIPI,
       a.IL, a.ILCE, a.MAHALLE,
       st.ISIM + ' ' + st.SOYISIM AS SATICI,
       al.ISIM + ' ' + al.SOYISIM AS ALICI,
       o.ODEME_YONTEMI, o.ONAY_DURUMU
FROM SATIS s
INNER JOIN EV e ON s.TAPU_NO = e.TAPU_NO
INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
INNER JOIN SATICI st ON s.SATICI_ID = st.SATICI_ID
INNER JOIN ALICI al ON s.ALICI_ID = al.ALICI_ID
INNER JOIN ODEME o ON s.SATIS_NO = o.SATIS_NO;

-- 5. Ev sahiplerinin sahip oldukları evleri gösteren stored procedure
CREATE PROCEDURE sp_EvSahibiEvleri
    @evSahibiID INT
AS
BEGIN
    SELECT e.TAPU_NO, e.FIYAT, e.ODA_SAYISI, e.METRE_KARE, e.KONUT_TIPI, e.DURUM,
           a.IL, a.ILCE, a.MAHALLE, a.SOKAK,
           CASE 
               WHEN e.DURUM = 'Satılık' THEN 
                   CASE 
                       WHEN EXISTS (SELECT 1 FROM ILAN WHERE TAPU_NO = e.TAPU_NO) THEN 'İlanda'
                       ELSE 'İlansız'
                   END
               WHEN e.DURUM = 'Satıldı' THEN 
                   (SELECT CONVERT(VARCHAR, s.SATIS_TARIHI, 103) FROM SATIS s WHERE s.TAPU_NO = e.TAPU_NO)
               ELSE e.DURUM
           END AS DURUM_DETAYI
    FROM EV e
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    WHERE e.EV_SAHIBI_ID = @evSahibiID
    ORDER BY e.DURUM;
END;

-- 6. İlan detayları view oluşturma
CREATE VIEW vw_IlanDetaylari AS
SELECT i.ILAN_ID, i.BASLIK, i.ACIKLAMA, i.YAYIN_TARIHI, i.FIYAT,
       e.TAPU_NO, e.ODA_SAYISI, e.METRE_KARE, e.KAT_SAYISI, e.KONUT_TIPI, e.YAPIM_YILI,
       a.IL, a.ILCE, a.MAHALLE, a.SOKAK,
       s.ISIM + ' ' + s.SOYISIM AS SATICI_ADI,
       s.TELEFON AS SATICI_TELEFON,
       em.SIRKET_ADI AS EMLAK_SIRKETI,
       (SELECT COUNT(*) FROM FAVORILER WHERE ILAN_ID = i.ILAN_ID) AS FAVORI_SAYISI,
       (SELECT COUNT(*) FROM EV_RESIMLERI WHERE TAPU_NO = e.TAPU_NO) AS RESIM_SAYISI
FROM ILAN i
INNER JOIN EV e ON i.TAPU_NO = e.TAPU_NO
INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
INNER JOIN SATICI s ON i.SATICI_ID = s.SATICI_ID
LEFT JOIN EMLAK_SIRKETI em ON s.FIRMA_NO = em.FIRMA_NO;

-- 7. Trigger: Ev satıldığında durumunu otomatik güncelleme
CREATE TRIGGER trg_EvSatisGuncelle
ON SATIS
AFTER INSERT
AS
BEGIN
    UPDATE EV
    SET DURUM = 'Satıldı'
    FROM EV
    INNER JOIN inserted i ON EV.TAPU_NO = i.TAPU_NO;
    
    -- İlanları da kaldır
    DELETE FROM ILAN
    WHERE TAPU_NO IN (SELECT TAPU_NO FROM inserted);
END;
GO

-- 8. Trigger: Ev durumu değiştiğinde ilgili rezervasyonları güncelleme
CREATE TRIGGER trg_EvDurumuRezervasyonGuncelle
ON EV
AFTER UPDATE
AS
BEGIN
    IF UPDATE(DURUM)
    BEGIN
        -- Eğer ev satıldıysa bekleyen rezervasyonları iptal et
        UPDATE REZERVASYON
        SET DURUM = 'İptal Edildi'
        FROM REZERVASYON r
        INNER JOIN inserted i ON r.TAPU_NO = i.TAPU_NO
        WHERE i.DURUM = 'Satıldı' AND r.DURUM = 'Beklemede';
    END
END;
GO

-- 9. Trigger: Yeni ilan eklendiğinde abonelere bildirim gönderme
CREATE TRIGGER trg_YeniIlanBildirim
ON ILAN
AFTER INSERT
AS
BEGIN
    -- Yeni eklenmiş her ilan için kullanıcılara bildirim ekle
    INSERT INTO BILDIRIM (KULLANICI_ID, BASLIK, GONDERME_TARIHI, BILDIRIM_TIPI)
    SELECT k.KULLANICI_ID, 
           'Yeni İlan: ' + i.BASLIK, 
           GETDATE(), 
           'Yeni İlan'
    FROM KULLANICI_HESABI k
    CROSS JOIN inserted i
    -- Örnek olarak sadece aktif kullanıcılara gönderelim
    -- Gerçek sistemde belirli bir şehir/ilçe tercihine göre filtrelenebilir
    WHERE EXISTS (
        SELECT 1 FROM ADRES a 
        WHERE a.TAPU_NO = i.TAPU_NO 
        AND a.IL IN ('İstanbul', 'Ankara', 'İzmir') -- Örnek filtre
    );
END;
GO

-- 10. Function: Ev değerlendirme puanlarını hesaplama
CREATE FUNCTION fn_EvDegerlendirmePuani (@tapuNo NVARCHAR(20))
RETURNS DECIMAL(3,2)
AS
BEGIN
    DECLARE @ortalamaPuan DECIMAL(3,2);
    
    SELECT @ortalamaPuan = AVG(CAST(PUAN AS DECIMAL(3,2)))
    FROM DEGERLENDIRME
    WHERE TAPU_NO = @tapuNo;
    
    RETURN ISNULL(@ortalamaPuan, 0);
END;
GO

-- 11. Function: Fiyat aralığına göre ev sayısını hesaplama
CREATE FUNCTION fn_FiyatAraliginaGoreEvSayisi 
(
    @minFiyat DECIMAL(15, 2),
    @maxFiyat DECIMAL(15, 2)
)
RETURNS INT
AS
BEGIN
    DECLARE @evSayisi INT;
    
    SELECT @evSayisi = COUNT(*)
    FROM EV
    WHERE FIYAT BETWEEN @minFiyat AND @maxFiyat
    AND DURUM = 'Satılık';
    
    RETURN @evSayisi;
END;
GO

-- 12. Kullanıcı tarafından görülen en popüler ilanları listeleyen stored procedure
CREATE PROCEDURE sp_EnPopulerIlanlar
    @limit INT = 10
AS
BEGIN
    SELECT i.ILAN_ID, i.BASLIK, i.FIYAT, e.ODA_SAYISI, e.METRE_KARE,
           a.IL, a.ILCE, a.MAHALLE,
           COUNT(f.FAVORI_ID) AS FAVORI_SAYISI,
           dbo.fn_EvDegerlendirmePuani(e.TAPU_NO) AS ORTALAMA_PUAN
    FROM ILAN i
    INNER JOIN EV e ON i.TAPU_NO = e.TAPU_NO
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    LEFT JOIN FAVORILER f ON i.ILAN_ID = f.ILAN_ID
    GROUP BY i.ILAN_ID, i.BASLIK, i.FIYAT, e.ODA_SAYISI, e.METRE_KARE, 
             a.IL, a.ILCE, a.MAHALLE, e.TAPU_NO
    ORDER BY COUNT(f.FAVORI_ID) DESC, dbo.fn_EvDegerlendirmePuani(e.TAPU_NO) DESC
    OFFSET 0 ROWS
    FETCH NEXT @limit ROWS ONLY;
END;
GO

-- 13. Son X gün içinde satılan evleri listeleyen stored procedure
CREATE PROCEDURE sp_SonGunlerdeSatilanEvler
    @gunSayisi INT = 30
AS
BEGIN
    SELECT s.SATIS_NO, s.SATIS_TARIHI, s.SATIS_FIYATI,
           e.TAPU_NO, e.ODA_SAYISI, e.METRE_KARE, e.KONUT_TIPI,
           a.IL, a.ILCE, a.MAHALLE, a.SOKAK,
           st.ISIM + ' ' + st.SOYISIM AS SATICI,
           al.ISIM + ' ' + al.SOYISIM AS ALICI
    FROM SATIS s
    INNER JOIN EV e ON s.TAPU_NO = e.TAPU_NO
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    INNER JOIN SATICI st ON s.SATICI_ID = st.SATICI_ID
    INNER JOIN ALICI al ON s.ALICI_ID = al.ALICI_ID
    WHERE s.SATIS_TARIHI >= DATEADD(DAY, -@gunSayisi, GETDATE())
    ORDER BY s.SATIS_TARIHI DESC;
END;
GO

-- 14. View: Özet pazar istatistikleri
CREATE VIEW vw_PazarIstatistikleri AS
SELECT
    a.IL,
    a.ILCE,
    COUNT(CASE WHEN e.DURUM = 'Satılık' THEN 1 END) AS SATILIK_EV_SAYISI,
    COUNT(CASE WHEN e.DURUM = 'Satıldı' THEN 1 END) AS SATILMIS_EV_SAYISI,
    AVG(CASE WHEN e.DURUM = 'Satılık' THEN e.FIYAT END) AS ORTALAMA_SATILIK_FIYAT,
    AVG(CASE WHEN s.SATIS_NO IS NOT NULL THEN s.SATIS_FIYATI END) AS ORTALAMA_SATIS_FIYATI,
    AVG(CASE WHEN e.DURUM = 'Satılık' THEN e.METRE_KARE END) AS ORTALAMA_METREKARE,
    MAX(CASE WHEN e.DURUM = 'Satılık' THEN e.FIYAT END) AS EN_YUKSEK_FIYAT,
    MIN(CASE WHEN e.DURUM = 'Satılık' THEN e.FIYAT END) AS EN_DUSUK_FIYAT
FROM ADRES a
JOIN EV e ON a.TAPU_NO = e.TAPU_NO
LEFT JOIN SATIS s ON e.TAPU_NO = s.TAPU_NO
GROUP BY a.IL, a.ILCE;
GO

-- 15. Bir satıcının tüm ilanlarını listeleyen stored procedure
CREATE PROCEDURE sp_SaticiIlanlari
    @saticiID INT
AS
BEGIN
    SELECT i.ILAN_ID, i.BASLIK, i.YAYIN_TARIHI, i.FIYAT,
           e.ODA_SAYISI, e.METRE_KARE, e.KONUT_TIPI,
           a.IL, a.ILCE, a.MAHALLE,
           (SELECT COUNT(*) FROM FAVORILER WHERE ILAN_ID = i.ILAN_ID) AS FAVORI_SAYISI,
           (SELECT COUNT(*) FROM REZERVASYON WHERE TAPU_NO = e.TAPU_NO AND DURUM = 'Beklemede') AS BEKLEYEN_RANDEVU
    FROM ILAN i
    INNER JOIN EV e ON i.TAPU_NO = e.TAPU_NO
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    WHERE i.SATICI_ID = @saticiID
    ORDER BY i.YAYIN_TARIHI DESC;
END;
GO

-- 16. Kullanıcının favori ilanlarını listeleyen stored procedure
CREATE PROCEDURE sp_KullaniciFavorileri
    @kullaniciID INT
AS
BEGIN
    SELECT i.ILAN_ID, i.BASLIK, i.FIYAT,
           e.ODA_SAYISI, e.METRE_KARE, e.KONUT_TIPI,
           a.IL, a.ILCE, a.MAHALLE,
           s.ISIM + ' ' + s.SOYISIM AS SATICI,
           es.SIRKET_ADI AS EMLAK_SIRKETI,
           f.FAVORI_ID
    FROM FAVORILER f
    INNER JOIN ILAN i ON f.ILAN_ID = i.ILAN_ID
    INNER JOIN EV e ON i.TAPU_NO = e.TAPU_NO
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    INNER JOIN SATICI s ON i.SATICI_ID = s.SATICI_ID
    LEFT JOIN EMLAK_SIRKETI es ON s.FIRMA_NO = es.FIRMA_NO
    WHERE f.KULLANICI_ID = @kullaniciID
    ORDER BY i.FIYAT ASC;
END;
GO

-- 17. Sigorta bitiş tarihine göre uyarı bildirimi oluşturan stored procedure
CREATE PROCEDURE sp_SigortaBitisTarihiUyarisi
    @gunEsik INT = 30
AS
BEGIN
    -- Sigorta bitiş tarihine X gün kalan evlerin sahiplerine bildirim
    INSERT INTO BILDIRIM (KULLANICI_ID, BASLIK, GONDERME_TARIHI, BILDIRIM_TIPI)
    SELECT 
        -- Varsayalım ki ev sahipleri de kullanıcı tablosunda
        (SELECT KULLANICI_ID FROM KULLANICI_HESABI 
         WHERE EMAIL = (SELECT EMAIL FROM EV_SAHIBI WHERE EV_SAHIBI_ID = e.EV_SAHIBI_ID)),
        'Sigorta Bitiş Uyarısı: ' + CONVERT(VARCHAR, s.BITIS_TARIHI, 103) + ' tarihinde sona erecek',
        GETDATE(),
        'Sigorta Uyarısı'
    FROM SIGORTA s
    INNER JOIN EV e ON s.TAPU_NO = e.TAPU_NO
    WHERE 
        DATEDIFF(DAY, GETDATE(), s.BITIS_TARIHI) <= @gunEsik AND
        DATEDIFF(DAY, GETDATE(), s.BITIS_TARIHI) > 0;

    -- Sonuç olarak etkilenen ev sayısını dön
    SELECT COUNT(*) AS UyariGonderilenEvSayisi
    FROM SIGORTA
    WHERE DATEDIFF(DAY, GETDATE(), BITIS_TARIHI) <= @gunEsik AND
          DATEDIFF(DAY, GETDATE(), BITIS_TARIHI) > 0;
END;
GO

-- 18. Satış işlemlerini ve ilgili istatistikleri raporlayan stored procedure
CREATE PROCEDURE sp_SatisRaporu
    @baslangicTarihi DATE,
    @bitisTarihi DATE = NULL
AS
BEGIN
    -- Bitiş tarihi belirtilmemişse bugünü al
    IF @bitisTarihi IS NULL
        SET @bitisTarihi = GETDATE();
        
    -- Belirtilen tarih aralığında satışların özeti
    SELECT 
        a.IL,
        COUNT(*) AS SATIS_ADEDI,
        SUM(s.SATIS_FIYATI) AS TOPLAM_SATIS_TUTARI,
        AVG(s.SATIS_FIYATI) AS ORTALAMA_SATIS_TUTARI,
        MIN(s.SATIS_FIYATI) AS EN_DUSUK_SATIS,
        MAX(s.SATIS_FIYATI) AS EN_YUKSEK_SATIS,
        DATEPART(MONTH, s.SATIS_TARIHI) AS AY,
        DATEPART(YEAR, s.SATIS_TARIHI) AS YIL
    FROM SATIS s
    INNER JOIN EV e ON s.TAPU_NO = e.TAPU_NO
    INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
    WHERE s.SATIS_TARIHI BETWEEN @baslangicTarihi AND @bitisTarihi
    GROUP BY a.IL, DATEPART(MONTH, s.SATIS_TARIHI), DATEPART(YEAR, s.SATIS_TARIHI)
    ORDER BY a.IL, YIL, AY;
    
    -- Emlak şirketlerine göre satış performansı
    SELECT 
        em.SIRKET_ADI,
        COUNT(*) AS SATIS_ADEDI,
        SUM(s.SATIS_FIYATI) AS TOPLAM_SATIS_TUTARI,
        AVG(s.SATIS_FIYATI) AS ORTALAMA_SATIS_TUTARI
    FROM SATIS s
    INNER JOIN SATICI st ON s.SATICI_ID = st.SATICI_ID
    INNER JOIN EMLAK_SIRKETI em ON st.FIRMA_NO = em.FIRMA_NO
    WHERE s.SATIS_TARIHI BETWEEN @baslangicTarihi AND @bitisTarihi
    GROUP BY em.SIRKET_ADI
    ORDER BY TOPLAM_SATIS_TUTARI DESC;
    
    -- Satıcılara göre satış performansı
    SELECT 
        st.ISIM + ' ' + st.SOYISIM AS SATICI,
        em.SIRKET_ADI,
        COUNT(*) AS SATIS_ADEDI,
        SUM(s.SATIS_FIYATI) AS TOPLAM_SATIS_TUTARI
    FROM SATIS s
    INNER JOIN SATICI st ON s.SATICI_ID = st.SATICI_ID
    LEFT JOIN EMLAK_SIRKETI em ON st.FIRMA_NO = em.FIRMA_NO
    WHERE s.SATIS_TARIHI BETWEEN @baslangicTarihi AND @bitisTarihi
    GROUP BY st.ISIM, st.SOYISIM, em.SIRKET_ADI
    ORDER BY TOPLAM_SATIS_TUTARI DESC;
END;
GO

-- 19. Örnek sorgular

-- İstanbul'daki satılık evleri listeleme
EXEC sp_IlIlceGoreSatilikEvler @il = 'İstanbul';

-- 1.000.000 TL ile 3.000.000 TL arasındaki en az 3 odalı evleri listeleme
EXEC sp_EvAra @minFiyat = 1000000, @maxFiyat = 3000000, @minOdaSayisi = 3;

-- Ev detaylarını gösteren view'ı sorgulama
SELECT * FROM vw_EvDetaylari WHERE IL = 'İstanbul' AND DURUM = 'Satılık';

-- Satış özetini görüntüleme
SELECT * FROM vw_SatisOzeti;

-- Belirli bir ev sahibinin evlerini görüntüleme
EXEC sp_EvSahibiEvleri @evSahibiID = 1;

-- İlan detaylarını görüntüleme
SELECT * FROM vw_IlanDetaylari WHERE IL = 'Ankara';

-- En popüler 5 ilanı listeleme
EXEC sp_EnPopulerIlanlar @limit = 5;

-- Son 60 gün içinde satılan evleri listeleme
EXEC sp_SonGunlerdeSatilanEvler @gunSayisi = 60;

-- Pazar istatistiklerini görüntüleme
SELECT * FROM vw_PazarIstatistikleri WHERE IL = 'İstanbul';

-- Bir satıcının ilanlarını görüntüleme
EXEC sp_SaticiIlanlari @saticiID = 2;

-- Bir kullanıcının favori ilanlarını görüntüleme
EXEC sp_KullaniciFavorileri @kullaniciID = 1;

-- Bitiş tarihi yaklaşan sigorta poliçeleri için uyarı bildirimleri oluşturma
EXEC sp_SigortaBitisTarihiUyarisi @gunEsik = 60;

-- 2023 yılı satış raporunu görüntüleme
EXEC sp_SatisRaporu @baslangicTarihi = '2023-01-01', @bitisTarihi = '2023-12-31';

-- Belirli bir fiyat aralığındaki ev sayısını hesaplama
SELECT dbo.fn_FiyatAraliginaGoreEvSayisi(1000000, 2000000) AS EvSayisi;

-- Yüksek değerlendirme puanına sahip evleri listeleme
SELECT e.TAPU_NO, e.FIYAT, e.ODA_SAYISI, e.KONUT_TIPI, 
       a.IL, a.ILCE, a.MAHALLE,
       dbo.fn_EvDegerlendirmePuani(e.TAPU_NO) AS ORTALAMA_PUAN
FROM EV e
INNER JOIN ADRES a ON e.TAPU_NO = a.TAPU_NO
WHERE dbo.fn_EvDegerlendirmePuani(e.TAPU_NO) >= 4
ORDER BY ORTALAMA_PUAN DESC;