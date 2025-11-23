//####################################################
// グローバル変数
//####################################################
let selectedFile = null;
let fileInput, fileName, fileSize, loadButton, fileInfo;

//####################################################
// DOM描画時に実行
//#####################################################
document.addEventListener("DOMContentLoaded", function () {
    const uploadArea = document.getElementById("upload-area");

    //======================================
    // 「クリックしてファイルを選択」イベント
    //======================================
    //アップロードエリアをクリックしたとき
    fileInput = document.getElementById("file-input");
    uploadArea.addEventListener("click", function () {
        fileInput.click();
    });
    //ファイルを選択したとき
    fileInput.addEventListener("change", function (e) {
        handleFile(e.target.files[0]);
    });
    //======================================
    // 「ドラッグ＆ドロップ」イベント
    //======================================
    // ドラックしてアップロードエリアに入ったとき
    uploadArea.addEventListener("dragover", function (e) {
        e.preventDefault();
        uploadArea.classList.add("dragover");
    });
    // ドラックしてアップロードエリアから離れたとき
    uploadArea.addEventListener("dragleave", function (e) {
        uploadArea.classList.remove("dragover");
    });
    // アップロードエリアでドロップしたとき
    uploadArea.addEventListener("drop", function (e) {
        e.preventDefault();
        uploadArea.classList.remove("dragover");
        const dt = new DataTransfer();
        dt.items.add(e.dataTransfer.files[0]);
        fileInput.files = dt.files;
        handleFile(e.dataTransfer.files[0]);
    });
});
//####################################################
// 対象ファイル表示処理
//#####################################################
function handleFile(file) {
    fileName = document.getElementById("file-name");
    fileSize = document.getElementById("file-size");
    loadButton = document.getElementById("load-button");
    fileInfo = document.getElementById("file-info");
    if (file && file.name.endsWith(".csv")) {
        fileName.textContent = `ファイル名: ${file.name}`;
        fileSize.textContent = `サイズ: ${(file.size / 1024).toFixed(2)} KB`;
        fileInfo.classList.add("show");
        loadButton.disabled = false;
    } else {
        alert("CSVファイルを選択してください");
    }
}
