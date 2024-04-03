// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

function startProgressBar(duration) {
  const progressBar = document.getElementById("progress-bar");
  progressBar.style.width = "0%";
  progressBar.style.display = "block";

  let progress = 0;
  const intervalTime = duration / 100;
  const interval = setInterval(() => {
    progress += 1;
    progressBar.style.width = `${progress}%`;
    if (progress >= 100) clearInterval(interval);
  }, intervalTime);
}

function completeProgressBar() {
  const progressBar = document.getElementById("progress-bar");
  progressBar.style.width = "100%";
  setTimeout(() => {
    progressBar.style.display = "none";
    progressBar.style.width = "0%";
  }, 500);
}

document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector("form");
  if (form) {
    form.addEventListener("submit", (event) => {
      const duration = 35000;
      startProgressBar(duration);
      setTimeout(completeProgressBar, duration);
    });
  }
});
