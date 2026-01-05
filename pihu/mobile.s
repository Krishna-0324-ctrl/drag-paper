let highestZ = 1;

class Paper {
  holdingPaper = false;
  touchStartX = 0;
  touchStartY = 0;
  touchMoveX = 0;
  touchMoveY = 0;
  prevTouchX = 0;
  prevTouchY = 0;
  velX = 0;
  velY = 0;
  rotation = Math.random() * 30 - 15;
  currentPaperX = 0;
  currentPaperY = 0;
  rotating = false;

  init(paper) {

    paper.addEventListener('touchstart', (e) => {
      if (this.holdingPaper) return;

      this.holdingPaper = true;
      this.rotating = false;

      paper.style.zIndex = highestZ++;
      
      this.touchStartX = e.touches[0].clientX;
      this.touchStartY = e.touches[0].clientY;
      this.prevTouchX = this.touchStartX;
      this.prevTouchY = this.touchStartY;
    }, { passive: false });

    paper.addEventListener('touchmove', (e) => {
      e.preventDefault();

      if (!this.holdingPaper) return;

      if (!this.rotating) {
        this.touchMoveX = e.touches[0].clientX;
        this.touchMoveY = e.touches[0].clientY;

        this.velX = this.touchMoveX - this.prevTouchX;
        this.velY = this.touchMoveY - this.prevTouchY;

        this.currentPaperX += this.velX;
        this.currentPaperY += this.velY;

        this.prevTouchX = this.touchMoveX;
        this.prevTouchY = this.touchMoveY;
      }

      if (this.rotating && e.touches.length === 2) {
        const dx = e.touches[1].clientX - e.touches[0].clientX;
        const dy = e.touches[1].clientY - e.touches[0].clientY;
        this.rotation = Math.atan2(dy, dx) * 180 / Math.PI;
      }

      paper.style.transform =
        `translate(${this.currentPaperX}px, ${this.currentPaperY}px) rotate(${this.rotation}deg)`;
    }, { passive: false });

    paper.addEventListener('touchend', () => {
      this.holdingPaper = false;
      this.rotating = false;
    });

    // Enable rotation when two fingers are detected
    paper.addEventListener('touchstart', (e) => {
      if (e.touches.length === 2) {
        this.rotating = true;
      }
    });
  }
}

const papers = document.querySelectorAll('.paper');

papers.forEach(paper => {
  const p = new Paper();
  p.init(paper);
});
