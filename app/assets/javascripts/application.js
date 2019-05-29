// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage

//= require jquery3
//= require moment
//= require fullcalendar
//= require fullcalendar/lang/ja
//= require_tree .


$(function () {
    $("#calendar").fullCalendar({
        //ヘッダーの設定
        header: {
            left: "today month,basicWeek",
                center: "title",
                right: "prev next"
        },
        editable: true, // イベントを編集するか
            allDaySlot: false, // 終日表示の枠を表示するか
            eventDurationEditable: false, // イベント期間をドラッグしで変更するかどうか
            slotEventOverlap: false, // イベントを重ねて表示するか
            selectable: true,
            selectHelper: true,
            select: function(start, end, allDay) {
            日の枠内を選択したときの処理;
        },
        eventClick: function(calEvent, jsEvent, view) {
            イベントをクリックしたときの処理;
        },
        droppable: true, // イベントをドラッグできるかどうか
        events: '/tasks.json'
        /*events: [
            {
                title: "イベント",
                start: "2019-02-14"
            },
            {
                title: "イベント2",
                start: "2019-02-15"
            },
        ]*/
    });
});
