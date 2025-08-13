document.addEventListener('DOMContentLoaded', () => {
    const errorMessageEl = document.getElementById('error-message');
    const params = new URLSearchParams(window.location.search);

    if (params.has('error')) {
        errorMessageEl.textContent = 'Invalid username or password.';
    }

    if (params.has('logout')) {
        errorMessageEl.textContent = 'You have been logged out successfully.';
        errorMessageEl.classList.remove('error'); // Remove error class if present
        errorMessageEl.classList.add('success'); // Add success class
    }
});