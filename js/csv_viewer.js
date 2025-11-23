//####################################################
// DOM描画時に実行
//#####################################################
document.addEventListener("DOMContentLoaded", function () {
    const backBtn = document.getElementById("back-btn");
    backBtn.addEventListener("click", function () {
        window.location.href = "/cgi-bin/input_csv.cgi";
    });
});
