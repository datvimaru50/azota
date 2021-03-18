const AZT_DOMAIN_NAME = "https://azota.vn";
const AZT_DEV_SERVER = "https://azota.vn/api";

// const AZT_DEV_SERVER = "http://192.168.1.34:5001/api";

const AZO_REGISTER = "$AZT_DEV_SERVER/auth/register";
const AZO_LOGIN = "$AZT_DEV_SERVER/auth/login";

const AZO_AUTH_INFO = "$AZT_DEV_SERVER/auth/info";
const AZO_AUTH_ZALO = "$AZT_DEV_SERVER/auth/AuhenByZalo";
const AZO_AUTH_APPLE = "$AZT_DEV_SERVER/auth/RegisterByAppleId";

const AZO_TOKEN_SAVE = "$AZT_DEV_SERVER/Firebase/SaveToken";
const AZO_TOKEN_DELETE = "$AZT_DEV_SERVER/Firebase/RemoveToken";
const AZO_GET_NOTIF = "$AZT_DEV_SERVER/Notice/GetObjs";

const AZO_HOMEWORK_INFO = "$AZT_DEV_SERVER/FrontHomework/GetObj";
const AZO_LOGIN_ANONYMOUS = "$AZT_DEV_SERVER/Auth/LoginAnonymous";

const AZO_UPDATE_PARENT = "$AZT_DEV_SERVER/FrontStudent/UpdateParent";

const AZO_ANSWER_SAVE = "$AZT_DEV_SERVER/FrontAnswer/SaveObj";
const AZO_S3SPACE_SAVE = "$AZT_DEV_SERVER/S3space/get_public_upload_url";

/* ERROR MESSAGE */
const ERR_INVALID_LOGIN_INFO = "Sai tên đăng nhập hoặc mật khẩu!";
const ERR_SERVER_CONNECT = "Kết nối tới máy chủ bị lỗi!";
const ERR_BAD_REQUEST = "Dữ liệu gửi lên không hợp lệ!";

const ERR_APPLE_SIGN_IN = "Đăng nhập với Apple thất bại!";
const ERR_APPLE_USER_CANCEL = "Bạn đã hủy bỏ đăng nhập với Apple!";
const ERR_APPLE_SIGNIN_NOT_AVAILABLE = "Điện thoại của bạn không hỗ trợ đăng nhập với Apple!";
const ERROR_SUBMIT_HOMEWORK = "Nộp bài không thành công!";

const ERR_UPDATE_PARENT = "Cập nhật phụ huynh không thành công!";

/* SUCCESS MESSAGE */
const SUCCESS_LOGIN = "Đăng nhập thành công!";
const SUCCESS_SUBMIT_HOMEWORK = "Nộp bài thành công!";
const SUCCESS_UPDATE_PARENT = "Cập nhật phụ huynh thành công!";

const SECRET_KEY =
    "eyJraWQiOiI1MjJXQVlVQU4zIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJBRDc0Mk05NDkyIiwiaWF0IjoxNjE0NjcyOTI0LCJleHAiOjE2MzAyMjQ5MjQsImF1ZCI6Imh0dHBzOi8vYXBwbGVpZC5hcHBsZS5jb20iLCJzdWIiOiJ2bi5henQuYXp0In0.eowrDUm17wfoSWJPpXkDaoNwn2lmjiG5E0bFyGpMDDKq6ng7C_5QYUJyUif5M6hC0H8EHc0LiQ93PWyGAMfz-g";
