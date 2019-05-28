$(document).ready(function() {
    $('.drawer').drawer();
    // ドロワーメニューが開いたとき
    $('.drawer').on('drawer.opened', function(){
        alert('ドロワーが開きました');
    });

    // ドロワーメニューが閉じたとき
    $('.drawer').on('drawer.closed', function(){
        alert('ドロワーが閉じられました');
    });
});
