//####################################################
// DOM描画時に実行
//#####################################################
document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("back-button").addEventListener("click", function () {
        redirectPostList();
    });
});
//======================
// 投稿画面へリダイレクト
//======================
function redirectPostList() {
    window.location.href = "/cgi-bin/post_list.cgi";
}
