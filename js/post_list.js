//####################################################
// DOM描画時に実行
//#####################################################
document.addEventListener("DOMContentLoaded", function () {
    //----------------------
    // 削除ボタンにクリックイベントを付与
    //----------------------
    const deleteButtons = document.getElementsByName("delete-button");
    Array.from(deleteButtons).forEach(function (button) {
        button.addEventListener("click", function () {
            // クリックされたボタン要素を引数で渡す
            delete_post(this);
        });
    });
});
//======================
// 削除処理へリクエストを送信
// @param クリックされたボタン要素
//======================
async function delete_post(clickDeleteButtonElement) {
    try {
        // クリックされたボタン要素の親要素の中で一番近いtrのIDを返却
        const deletePostId = clickDeleteButtonElement.closest("tr").id;
        const requestData = { deletePostId: deletePostId };
        //----------------------
        // 削除処理を非同期で実行
        //----------------------
        const response = await fetch("/cgi-bin/perl/delete_post.pl", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(requestData),
        });
        // HTTPステータスコードのチェック
        if (!response.ok) {
            throw new Error();
        }
        const result = await response.json();
        //----------------------
        // 成功したとき、一覧画面を再描画
        // 失敗したとき、システムエラー画面に遷移
        //----------------------
        if (result.status === "success") {
            window.location.href = "/cgi-bin/post_list.cgi";
        } else {
            window.location.href = "/cgi-bin/system_error.cgi";
        }
    } catch (error) {
        window.location.href = "/cgi-bin/system_error.cgi";
    }
}
