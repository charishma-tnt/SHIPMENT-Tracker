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
  
  alert('Track Shipment functionality is not yet implemented.');
}

function toggleRole() {
  alert('Role toggle functionality is not yet implemented.');
}

function toggleSidebar() {
  const sidebar = document.querySelector('aside');
  if (!sidebar) return;
  if (sidebar.classList.contains('open')) {
    sidebar.classList.remove('open');
    sidebar.classList.add('closed');
  } else {
    sidebar.classList.remove('closed');
    sidebar.classList.add('open');
  }
}

// Export functions to global scope so they can be called from inline onclick handlers
window.showCreateForm = showCreateForm;
window.trackShipment = trackShipment;
window.toggleRole = toggleRole;
window.toggleSidebar = toggleSidebar;
