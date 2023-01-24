window.addEventListener("load", function(){
var speed = 1; //スクロール量（1 = 1px）
var interval = 100; //スクロール間隔（1000 = 1秒）
var scrollTop = $(window).scrollTop(); // 現在のスクロール量を計測

// スタートボタンがクリックされた時
$('#start').off('click');  // on clickの重複防止のため
$('#start').on('click', function(){

  /* スタートボタンを非表示にして、再生ボタンを表示 */
  $(this).hide();
  $('#stop').show();

  var speed = scrollTop + speed; // 次の移動先までの距離を指定
  var scroll = setInterval(function() {
    window.scrollBy(0, 12);   // スクロールさせる
    $('#stop').off('click');      // on clickの重複防止のため

    //スクロール中に停止ボタンが押された時
    $('#stop').on('click', function(){
      clearInterval(scroll);      // setIntervalの処理を停止
      $(this).hide();             // 停止ボタンを非表示にして、
      $('#start').show();         // 再生ボタンを表示

    });

  },interval);  // setIntervalを変数intervalの間隔で繰り返す。
});
})