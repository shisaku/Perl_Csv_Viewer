//####################################################
// DOM描画時に実行
//#####################################################
document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("back-button").addEventListener("click", function () {
        redirectPostList();
    });
});
//======================
// CSV読込画面へリダイレクト
//======================
function redirectPostList() {
    window.location.href = "/cgi-bin/input_csv.cgi";
}
