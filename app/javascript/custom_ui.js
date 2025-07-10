// JavaScript functions to handle UI interactions referenced in layout

function showCreateForm() {
  const createForm = document.getElementById('createShipmentForm');
  const shipmentsView = document.getElementById('shipmentsView');
  const dashboardView = document.getElementById('dashboardView');
  if (createForm && shipmentsView && dashboardView) {
    createForm.classList.remove('hidden');
    shipmentsView.classList.add('hidden');
    dashboardView.classList.add('hidden');
  }
}

function trackShipment() {
  // For demonstration, just alert or implement tracking UI toggle
  alert('Track Shipment functionality is not yet implemented.');
}

function toggleRole() {
  // For demonstration, just alert or implement role toggle logic
  alert('Role toggle functionality is not yet implemented.');
}

// Export functions to global scope so they can be called from inline onclick handlers
window.showCreateForm = showCreateForm;
window.trackShipment = trackShipment;
window.toggleRole = toggleRole;
