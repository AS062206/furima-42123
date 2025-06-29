const price = () => {
  const priceInput = document.getElementById("item-price")
  const commissionDisplay = document.getElementById("add-tax-price")
  const profitDisplay = document.getElementById("profit")

  priceInput.addEventListener("input", () => {
    const price = parseInt(priceInput.value, 10)
    if (isNaN(price) || price < 300 || price > 9999999) {
      commissionDisplay.textContent = "0"
      profitDisplay.textContent = "0"
      return
    }

    const commission = Math.floor(price * 0.1)
    const profit = price - commission;

    commissionDisplay.textContent = commission.toLocaleString()
    profitDisplay.textContent = profit.toLocaleString()
  })

  if (priceInput.value) {
    const initialPrice = parseInt(priceInput.value, 10);
    if (!isNaN(initialPrice) && initialPrice >= 300 && initialPrice <= 9999999) {
      const initialCommission = Math.floor(initialPrice * 0.1);
      const initialProfit = initialPrice - initialCommission;
      commissionDisplay.textContent = initialCommission.toLocaleString();
      profitDisplay.textContent = initialProfit.toLocaleString();
    }
  }
}

document.addEventListener("DOMContentLoaded", price)
window.addEventListener("turbo:load", price);
window.addEventListener("turbo:render", price);