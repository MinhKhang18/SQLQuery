USE QUAN_LY_PHONG_HAT
-- Liệt kê MaDP, MaDV, SoLuong của tất cả các dịch vụ có số lượng lớn hơn 3 và nhỏ hơn 10
SELECT MaDP, MaDV, SoLuong 
FROM CHI_TIET_SD_DV
WHERE SoLuong BETWEEN 4 AND 9

-- Cập nhật dữ liệu trên trường GiaPhong thuộc bảng PHONG tăng lên 10,000 VNĐ so với giá phòng hiện tại, chỉ cập nhật giá phòng của những phòng có số khách tối đa lớn hơn
UPDATE PHONG 
SET GiaPhong = GiaPhong + 10.000
WHERE SoKhachToiDa > 10

-- Xóa tất cả những đơn đặt phòng (từ bảng DAT_PHONG) có trạng thái đặt (TrangThaiDat) là “Da huy”
DELETE FROM DAT_PHONG 
WHERE TrangThaiDat = 'DA HUY'

-- Hiển thị TenKH của những khách hàng có tên bắt đầu là một trong các ký tự “H”, “N”, “M” và có độ dài tối đa là 20 ký tự.
SELECT TenKH
FROM KHACH_HANG
WHERE TenKH LIKE '[HNM]%' AND LEN(TenKH) <= 20

--  Hiển thị TenKH của tất cả các khách hàng có trong hệ thống, TenKH nào trùng nhau thì chỉ hiển thị một lần
SELECT DISTINCT TenKH
FROM KHACH_HANG

SELECT TenKH
FROM KHACH_HANG
GROUP BY TenKH

-- Hiển thị MaDV, TenDV, DonViTinh, DonGia của những dịch vụ đi kèm có DonViTinh là “lon” và có DonGia lớn hơn 10,000 VNĐ hoặc những dịch vụ đi kèm có DonViTinh là “Cai” và có DonGia nhỏ hơn 5,000 VNĐ
SELECT *
FROM DICH_VU_DI_KEM
WHERE (DonViTinh LIKE 'LON' AND DonGia > 10) 
OR (DonViTinh LIKE 'CAI' AND DonGia < 5)


-- Hiển thị MaDatPhong, MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, MaKH, TenKH, SoDT, NgayDat, GioBatDau, GioKetThuc, MaDichVu, SoLuong, DonGia của những đơn đặt phòng có năm đặt phòng là “2016”, “2017” và đặt những phòng có giá phòng > 50,000 VNĐ/ 1 giờ
SELECT DP.MaDP, DP.MaPhong, P.LoaiPhong, P.GiaPhong,
P.SoKhachToiDa, KH.MaKH, KH.TenKH, KH.SoDT, DP.NgayDat,
DP.GioKetThuc, DP.GioBatDau, CT.MaDV, CT.SoLuong, DV.DonGia
FROM DAT_PHONG DP
JOIN KHACH_HANG KH ON DP.MaKH = KH.MaKH
JOIN PHONG P ON P.MaPhong = DP.MaPhong
JOIN CHI_TIET_SD_DV CT ON CT.MaDP = DP.MaDP
JOIN DICH_VU_DI_KEM ON DV.MaDV = CT.MaDV
WHERE (YEAR(DP.NgayDat) = 2016 OR YEAR(DP.NgayDat) = 2018) AND P.GiaPhong > 50


-- Hiển thị MaDatPhong, MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, MaKH, TenKH, SoDT, NgayDat, GioBatDau, GioKetThuc, MaDichVu, SoLuong, DonGia của những đơn đặt phòng có năm đặt phòng là “2016”, “2017” và đặt những phòng có giá phòng > 50,000 VNĐ/ 1 giờ
SELECT DP.MaDP, P.MaPhong, P.LoaiPhong, P.GiaPhong, KH.TenKH, DP.NgayDat,
(P.GiaPhong * DATEDIFF(HOUR, DP.GioKetThuc, DP.GioBatDau)) AS TongTienHat,
SUM(CT.SoLuong * CT.DonGia) AS TongTienSuDungDichVu,
(P.GiaPhong * DATEDIFF(HOUR, DP.GioKetThuc, DP.GioBatDau) + CT.SoLuong * CT.DonGia) AS TongTienThanhToanTuongUng
FROM PHONG P
JOIN DAT_PHONG DP ON P.MaPhong = DP.MaPhong
JOIN KHACH_HANG KH ON DP.MaKH = KH.MaKH
JOIN CHI_TIET_SD_DV CT ON CT.MaDP = DP.MaDP 
JOIN DICH_VU_DI_KEM DVDK ON DVDK.MaDV = CT.MaDV
GROUP BY DP.MaDP, P.MaPhong, P.LoaiPhong, P.GiaPhong, KH.TenKH, DP.NgayDat

-- Hiển thị MaKH, TenKH, DiaChi, SoDT của những khách hàng đã từng đặt phòng karaoke có địa chỉ ở “Hoa xuan”.
SELECT MaKH, TenKH, DiaChi, SoDT
FROM KHACH_HANG
WHERE KHACH_HANG.DiaChi = 'Hoa xuan'
AND EXISTS (SELECT * FROM DAT_PHONG WHERE DAT_PHONG.MaKH = KHACH_HANG.MaKH)

-- Hiển thị MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, SoLanDat của những phòng được khách hàng đặt có số lần đặt lớn hơn 2 lần và trạng thái đặt là “Da dat”.
SELECT DP.MaPhong, P.LoaiPhong, P.SoKhachToiDa,
P.GiaPhong, COUNT(MaDP) AS SOLUONGDAT
FROM DAT_PHONG DP
JOIN PHONG P ON DP.MaPhong = P.MaPhong
WHERE DP.TrangThaiDat = 'DA DAT'
GROUP BY DP.MaPhong, P.LoaiPhong, P.SoKhachToiDa, P.GiaPhong
HAVING COUNT(MaDP) > 2

