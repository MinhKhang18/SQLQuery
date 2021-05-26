CREATE DATABASE QUANLYXE
GO
USE QUANLYXE
GO

CREATE TABLE MUCPHI (
	MaMP VARCHAR(10) NOT NULL PRIMARY KEY,
	DonGia DECIMAL(6,3) NOT NULL,
	MoTa VARCHAR(255) NULL 
)

CREATE TABLE DONGXE (
	DongXe NVARCHAR(10) NOT NULL PRIMARY KEY,
	HangXe NVARCHAR(10) NOT NULL,
	SoChoNgoi INT NOT NULL
)

CREATE TABLE NHACUNGCAP (
	MaNhaCC NVARCHAR(10) NOT NULL PRIMARY KEY,
	TenNhaCC NVARCHAR(25) NOT NULL,
	DiaChi NVARCHAR(30) NOT NULL,
	SoDT INT NULL,
	MaSoThue INT NOT NULL
)

CREATE TABLE LOAIDICHVU (
	MaLoaiDV NVARCHAR(25) NOT NULL PRIMARY KEY,
	TenLoaiDV NVARCHAR(30)
)

CREATE TABLE DANGKICUNGCAP (
	MaDKCC NVARCHAR(10) NOT NULL PRIMARY KEY,
	MaNhaCC NVARCHAR(10) NOT NULL,
	MaLoaiDV NVARCHAR(25) NOT NULL,
	DongXe NVARCHAR(10) NOT NULL,
	MaMP VARCHAR(10) NOT NULL,
	NgayBDCC DATE,
	NgayKTCC DATE,
	SoLuongXeDK INT NOT NULL,
	FOREIGN KEY (MaNhaCC) REFERENCES dbo.NHACUNGCAP(MaNhaCC),
	FOREIGN KEY (MaLoaiDV) REFERENCES dbo.LOAIDICHVU(MaLoaiDV),
	FOREIGN KEY (DongXe) REFERENCES dbo.DONGXE(DongXe),
	FOREIGN KEY (MaMP) REFERENCES dbo.MUCPHI(MaMP)
)

INSERT INTO dbo.MUCPHI(MaMP,DonGia,MoTa) VALUES
('MP01', '10.000', 'Ap dung tu ngay 1/2015'),
('MP02', '15.000', 'Ap dung tu ngay 2/2015'),
('MP03', '20.000', 'Ap dung tu ngay 1/2010'),
('MP04', '25.000', 'Ap dung tu ngay 2/2011');

INSERT INTO dbo.DONGXE(DongXe,HangXe,SoChoNgoi) VALUES
('Hiace', 'Toyota', 16),
('Vios', 'Toyota', 5),
('Escape', 'Ford', 5),
('Cerato', 'KIA', 7),
('Forte', 'KIA', 5),
('Starex', 'Huyndai', 7),
('Grand-i10', 'Huyndai', 7);

INSERT INTO dbo.NHACUNGCAP(MaNhaCC,TenNhaCC,DiaChi,SoDT,MaSoThue) VALUES
('NCC001', N'Cty TNHH Toàn Phát', 'Hai Chau', '1133999888', '568941'),
('NCC002', N'Cty Cổ Phần Đông Du', 'Lien Chieu', '1133999889', '456789'),
('NCC003', N'Ông Nguyễn Văn A', 'Hoa Thuan', '1133999890', '321456'),
('NCC004', N'Cty Cổ Phần Toàn Cầu Xanh', 'Hai Chau', '113658945', '513364'),
('NCC005', N'Cty TNHH AMA', 'Thanh Khe', '0503875466', '546546'),
('NCC006', N'Bà Trần Thị Bích Vân', 'Lien Chieu', '051587469', '524545'),
('NCC007', N'Cty TNHH Phan Thành', 'Thanh Khe', '051137456', '113021'),
('NCC008', N'Ông Phan Đình Nam', 'Hoa Thuan', '051132456', '121230'),
('NCC009', N'Tập đoàn Đông Nam Á', 'Lien Chieu', '053987121', '533654'),
('NCC010', N'Cty Cổ Phần Rạng đông', 'Lien Chieu', '051139654', '187864');

INSERT INTO dbo.LOAIDICHVU(MaLoaiDV,TenLoaiDV) VALUES
('DV01', N'Dịch vụ xe taxi'),
('DV02', N'Dịch vụ xe buýt tuyến cố định'),
('DV03', N'Dịch vụ thuê xe theo hợp đồng')
 
INSERT INTO dbo.DANGKICUNGCAP(MaDKCC,MaNhaCC,MaLoaiDV,DongXe,MaMP,NgayBDCC,NgayKTCC,SoLuongXeDK) VALUES
('DK001', 'NCC001', 'DV01', 'Hiace', 'MP01', '2015/11/20', '2016/11/20', 1),
('DK002', 'NCC002', 'DV02', 'Vios', 'MP02', '2015/11/20', '2017/11/20', 2),
('DK003', 'NCC003', 'DV03', 'Escape', 'MP03', '2017/11/20', '2018/11/20', 3),
('DK004', 'NCC005', 'DV01', 'Cerato', 'MP04', '2015/11/20', '2019/11/20', 4),
('DK005', 'NCC002', 'DV02', 'Forte', 'MP03', '2019/11/20', '2020/11/20', 5),
('DK006', 'NCC004', 'DV03', 'Starex', 'MP04', '2016/11/10', '2021/11/20', 6),
('DK007', 'NCC005', 'DV01', 'Cerato', 'MP03', '2015/11/30', '2016/01/25', 7)


-- Liệt kê những dòng xe có số chỗ ngồi trên 5 chỗ
SELECT * 
FROM dbo.DONGXE
WHERE SoChoNgoi > 5

/* Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp những dòng xe
thuộc hãng xe “Toyota” với mức phí có đơn giá là 15.000 VNĐ/km hoặc những dòng xe
thuộc hãng xe “KIA” với mức phí có đơn giá là 20.000 VNĐ/km */
SELECT *
FROM dbo.NHACUNGCAP NCP
JOIN dbo.DANGKICUNGCAP DKCC ON DKCC.MaNhaCC = NCP.MaNhaCC
JOIN dbo.MUCPHI MP ON MP.MaMP = DKCC.MaMP
JOIN dbo.DONGXE DX ON DX.DongXe = DKCC.DongXe
WHERE (DX.HangXe LIKE 'Toyota' AND MP.DonGia = 15.000)
OR (DX.HangXe LIKE 'KIA' AND MP.DonGia = 20.000)

/* Liệt kê thông tin toàn bộ nhà cung cấp được sắp xếp tăng dần theo tên nhà cung
cấp và giảm dần theo mã số thuế */
SELECT *
FROM dbo.NHACUNGCAP
ORDER BY TenNhaCC ASC, MaSoThue DESC

/* Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với
yêu cầu chỉ đếm cho những nhà cung cấp thực hiện đăng ký cung cấp có ngày bắt đầu
cung cấp là “20/11/2015” */
SELECT NCC.TenNhaCC, COUNT(MaDKCC)
FROM dbo.DANGKICUNGCAP DKCP
JOIN dbo.NHACUNGCAP NCC ON NCC.MaNhaCC = DKCP.MaNhaCC
WHERE DKCP.NgayBDCC LIKE '20/11/2015'
GROUP BY NCC.TenNhaCC


/*Liệt kê tên của toàn bộ các hãng xe có trong cơ sở dữ liệu với yêu cầu mỗi hãng xe
chỉ được liệt kê một lần*/
SELECT DISTINCT HangXe
FROM dbo.DONGXE

SELECT HangXe
FROM dbo.DONGXE
GROUP BY HangXe


/*Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện
thuộc dòng xe “Hiace” hoặc từng đăng ký cung cấp phương tiện thuộc dòng xe “Cerato”*/
SELECT NCC.*
FROM dbo.NHACUNGCAP NCC
JOIN dbo.DANGKICUNGCAP DK ON NCC.MaNhaCC = DK.MaDKCC
JOIN dbo.DONGXE DX ON DX.DongXe = DK.DongXe
WHERE DX.DongXe LIKE 'Hiace' OR dx.DongXe LIKE 'Cerato'
 

/*Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp
phương tiện lần nào cả.*/
SELECT NCC.*
FROM dbo.NHACUNGCAP NCC
WHERE  NOT EXISTS (
	SELECT DK.*
	FROM dbo.DANGKICUNGCAP DK
	WHERE DK.MaNhaCC = NCC.MaNhaCC
)