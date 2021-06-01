CREATE DATABASE THUCTAP
USE THUCTAP
GO

CREATE TABLE Khoa (
	MaKhoa CHAR(10) PRIMARY KEY,
	TenKhoa CHAR(30),
	DienThoai CHAR(10)
)

CREATE TABLE GiangVien (
	MaGV INT PRIMARY KEY,
	HoTenGV CHAR(30),
	Luong DECIMAL(5,2),
	MaKhoa CHAR(10),
	FOREIGN KEY (MaKhoa) REFERENCES dbo.Khoa(MaKhoa)
)

CREATE TABLE SinhVien (
	MaSV INT PRIMARY KEY,
	HoTenSV CHAR(30),
	MaKhoa CHAR(10),
	NamSinh INT,
	QueQuan CHAR(30),
	FOREIGN KEY (MaKhoa) REFERENCES dbo.Khoa(MaKhoa)
)

CREATE TABLE DeTai (
	MaDT CHAR(10) PRIMARY KEY,
	TenDT CHAR(30),
	KinhPhi INT, 
	NoiThucTap CHAR(30)
)

CREATE TABLE HuongDan (
	MaSV INT PRIMARY KEY,
	MaDT CHAR(10) FOREIGN KEY REFERENCES dbo.DeTai(MaDT),
	MaGV INT FOREIGN KEY REFERENCES dbo.GiangVien(MaGV),
	KetQua DECIMAL(5,2)
)

-- Insert data
INSERT INTO dbo.Khoa(MaKhoa,TenKhoa,DienThoai) VALUES
('Geo','Dia ly va QLTN',3855413),
('Math','Toan',3855411),
('Bio','Cong nghe Sinh hoc',3855412);

INSERT INTO dbo.GiangVien(MaGV,HoTenGV,Luong,MaKhoa) VALUES
(11,'Thanh Binh',700,'Geo'),    
(12,'Thu Huong',500,'Math'),
(13,'Chu Vinh',650,'Geo'),
(14,'Le Thi Ly',500,'Bio'),
(15,'Tran Son',900,'Math');

INSERT INTO dbo.SinhVien(MaSV,HoTenSV,MaKhoa,NamSinh,QueQuan) VALUES
(1,'Le Van Son','Bio',1990,'Nghe An'),
(2,'Nguyen Thi Mai','Geo',1990,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1992,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1989,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1991,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',1992,'Nghe An');

INSERT INTO dbo.DeTai(MaDT,TenDT,KinhPhi,NoiThucTap) VALUES
('Dt01','GIS',100,'Nghe An'),
('Dt02','ARC GIS',500,'Nam Dinh'),
('Dt03','Spatial DB',100, 'Ha Tinh'),
('Dt04','MAP',300,'Quang Binh' );

INSERT INTO dbo.HuongDan(MaSV,MaDT,MaGV,KetQua) VALUES
(1,'Dt01',13,8),
(2,'Dt03',14,0),
(3,'Dt03',12,10),
(5,'Dt04',14,7),
(6,'Dt01',13,Null),
(7,'Dt04',11,10),
(8,'Dt03',15,6);
 

-- QUERY

-- Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên
SELECT MaGV, HoTenGV, TenKhoa
FROM dbo.GiangVien JOIN  dbo.Khoa
on dbo.Khoa.MaKhoa = dbo.GiangVien.MaKhoa

-- Cho biết tên đề tài không có sinh viên nào thực tập
SELECT TenDT
FROM dbo.DeTai DT
WHERE NOT EXISTS (
	SELECT *
	FROM dbo.HuongDan HD
	WHERE DT.MaDT = HD.MaDT
)

/*Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên 
của khoa ‘DIA LY va QLTN’*/
SELECT GV.MaGV, GV.HoTenGV, K.TenKhoa
FROM dbo.GiangVien GV JOIN dbo.Khoa K
ON K.MaKhoa = GV.MaKhoa
WHERE K.TenKhoa = 'Dia ly va QLTN'

-- Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(MaSV)
FROM dbo.SinhVien
JOIN dbo.Khoa ON dbo.SinhVien.MaKhoa = dbo.Khoa.MaKhoa
WHERE dbo.Khoa.TenKhoa = 'Cong nghe Sinh hoc'


-- Đưa ra danh sách gồm mã số, họ tênvà tuổi của các sinh viên khoa ‘TOAN’
SELECT sv.MaSV, sv.HoTenSV,
(YEAR(GETDATE()) -  sv.NamSinh) AS TuoiSV
FROM dbo.SinhVien sv
JOIN dbo.Khoa K ON k.MaKhoa = sv.MaKhoa
WHERE k.TenKhoa = 'Toan'


-- Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(GV.MaGV)
FROM dbo.GiangVien GV
JOIN dbo.Khoa K ON K.MaKhoa = GV.MaKhoa
WHERE K.TenKhoa = 'Cong nghe sinh hoc'


-- Cho biết thông tin về sinh viên không tham gia thực tập
SELECT SV.Masv,SV.Hotensv
FROM SinhVien SV 
WHERE NOT EXISTS(
	SELECT HD.Masv
	FROM HuongDan HD 
	WHERE SV.Masv = HD.Masv
)

-- Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
SELECT k.MaKhoa, k.TenKhoa,
COUNT(gv.MaGV)
FROM dbo.Khoa k 
JOIN dbo.GiangVien gv
ON k.MaKhoa = gv.MaKhoa
GROUP BY k.MaKhoa, k.TenKhoa


-- Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
SELECT k.DienThoai
FROM dbo.Khoa k
JOIN dbo.SinhVien sv 
ON k.MaKhoa = sv.MaKhoa
WHERE sv.HoTenSV = 'Le Van Son'


-- Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
SELECT dt.MaDT, dt.TenDT
FROM dbo.DeTai dt
JOIN dbo.HuongDan hd
ON dt.MaDT = hd.MaDT
JOIN dbo.GiangVien gv
ON gv.MaGV = hd.MaGV
WHERE gv.HoTenGV = 'Tran Son'

-- Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
SELECT gv.MaGV, gv.HoTenGV, k.TenKhoa
FROM dbo.GiangVien gv JOIN dbo.Khoa k
ON gv.MaKhoa = k.MaKhoa
WHERE gv.MaGV IN (
	SELECT hd.MaGV 
	FROM dbo.HuongDan hd
	GROUP BY hd.MaGV
	HAVING COUNT(hd.MaGV) > 3
)

-- Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
SELECT MaDT, TenDT, KinhPhi
FROM dbo.DeTai
WHERE KinhPhi = (
	SELECT MAX(KinhPhi)
	FROM dbo.DeTai
)


-- Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
SELECT dt.MaDT, dt.TenDT
FROM dbo.DeTai dt
WHERE dt.MaDT IN (
	SELECT hd.MaDT
	FROM dbo.HuongDan hd
	GROUP BY hd.MaDT
	HAVING COUNT(hd.MaDT) > 2
)


-- Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
SELECT sv.MaSV, sv.HoTenSV, hd.KetQua
FROM dbo.SinhVien sv JOIN dbo.Khoa k
ON sv.MaKhoa = k.MaKhoa
JOIN dbo.HuongDan hd ON hd.MaSV = sv.MaSV
WHERE k.TenKhoa = 'Dia ly va QLTN'


-- Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
SELECT k.TenKhoa, COUNT(sv.MaSV) AS SoLuongSV
FROM dbo.Khoa K JOIN dbo.SinhVien SV
ON K.MaKhoa = SV.MaKhoa
GROUP BY K.TenKhoa


-- Cho biết thông tin về các sinh viên thực tập tại quê nhà
SELECT sv.* 
FROM dbo.SinhVien sv JOIN dbo.HuongDan hd
ON sv.MaSV = hd.MaSV
JOIN dbo.DeTai dt ON dt.MaDT = hd.MaDT
WHERE sv.QueQuan = dt.NoiThucTap


-- Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
SELECT sv.*
FROM dbo.SinhVien sv JOIN dbo.HuongDan hd
ON sv.MaSV = hd.MaSV
WHERE hd.KetQua IS NULL


-- Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
SELECT sv.*
FROM dbo.SinhVien sv JOIN dbo.HuongDan hd
ON sv.MaSV = hd.MaSV
WHERE hd.KetQua = 0