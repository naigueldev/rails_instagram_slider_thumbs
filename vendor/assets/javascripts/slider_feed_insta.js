$(document).ready(function(){
  $('#itemslider').carousel({ interval: 3000 });

  $('.carousel-showmanymoveone .item').each(function(){
    var itemToClone = $(this);

    for (var i=1;i<6;i++) {
      itemToClone = itemToClone.next();

      if (!itemToClone.length) {
        itemToClone = $(this).siblings(':first');
      }

      itemToClone.children(':first-child').clone().addClass("cloneditem-"+(i)).appendTo($(this));
    }
  });
});


function openModal() {
  document.getElementById('myModal').style.display = "block";
}
function params_code(code) {
  // $.get("/code_insta?code="+ code, function(){});
}

function closeModal() {
  document.getElementById('myModal').style.display = "none";
}

var slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
  showSlides(slideIndex += n);
}

function currentSlide(n) {
  showSlides(slideIndex = n);
}

function showSlides(n) {
  var i;
  var expandMode = document.getElementsByClassName("expandMode");
  var slides = document.getElementsByClassName("mySlides");
  var comments = document.getElementsByClassName("myComments");
  var dots = document.getElementsByClassName("demo");
  var captionText = document.getElementById("mediaLikesCount").getElementsByClassName("mediaLikesCount")[0];

  if (n > slides.length) {slideIndex = 1}
  if (n < 1) {slideIndex = slides.length}
  for (i = 0; i < expandMode.length; i++) {
    expandMode[i].style.display = "none";
  }
  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
  }
  for (i = 0; i < comments.length; i++) {
    comments[i].style.display = "none";
  }
  for (i = 0; i < dots.length; i++) {
    dots[i].className = dots[i].className.replace(" active", "");
  }
  expandMode[slideIndex-1].style.display = "block";
  slides[slideIndex-1].style.display = "block";
  comments[slideIndex-1].style.display = "block";

}
