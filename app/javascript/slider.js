document.addEventListener("turbolinks:load", function(){
  $(function(){
    $('.slider').slick({
      autoplay: true, //自動でスクロール
      autoplaySpeed: 0, //自動再生のスライド切り替えまでの時間を設定
      speed: 5000, //スライドが流れる速度を設定
      cssEase: "linear", //スライドの流れ方を等速に設定
      slidesToShow: 4, //表示するスライドの数
      swipe: false, // 操作による切り替えはさせない
      arrows: false, //矢印非表示
      pauseOnFocus: false, //スライダーをフォーカスした時にスライドを停止させるか
      pauseOnHover: false, //スライダーにマウスホバーした時にスライドを停止させるか
      responsive: [
        {
          breakpoint: 1024, // 768〜1023px以下のサイズに適用
          settings: {
            slidesToShow: 3,
          },
        },
        {
          breakpoint: 768, // 480〜767px以下のサイズに適用
          settings: {
            slidesToShow: 2,
          },
        },
        {
          breakpoint: 480, // 〜479px以下のサイズに適用
          settings: {
            slidesToShow: 1,
          },
        },
      ],
    });
  });
})