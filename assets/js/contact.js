(function () {
	'use strict';

	var form = document.getElementById('contact-form');
	if (!form) {
		return;
	}

	var statusElement = document.getElementById('form-status');
	var submitButton = form.querySelector('button[type="submit"]');
	var contactEmail = form.getAttribute('data-contact-email');
	var fallbackMessage = 'Sorry, something went wrong. Please try again or email ' + contactEmail + '.';

	function setStatus(message, isError) {
		statusElement.textContent = message;
		statusElement.classList.toggle('status--error', isError);
		statusElement.setAttribute('role', isError ? 'alert' : 'status');
		statusElement.setAttribute('aria-live', isError ? 'assertive' : 'polite');

		if (message) {
			statusElement.focus();
		}
	}

	form.addEventListener('submit', function (event) {
		if (!form.checkValidity()) {
			event.preventDefault();
			setStatus('Please complete the required fields before sending.', true);
			form.reportValidity();
			return;
		}

		event.preventDefault();
		form.setAttribute('aria-busy', 'true');
		submitButton.disabled = true;
		setStatus('Sending…', false);

		fetch(form.action, {
			method: 'POST',
			body: new FormData(form),
			headers: { Accept: 'application/json' }
		})
			.then(function (response) {
				if (response.ok) {
					form.reset();
					setStatus('Thanks — your message was sent.', false);
					return null;
				}

				return response.json().catch(function () {
					return {};
				}).then(function (data) {
					var message = data.errors
						? data.errors.map(function (error) { return error.message; }).join(', ')
						: fallbackMessage;
					var submissionError = new Error(message);
					submissionError.isFormspreeResponse = true;
					throw submissionError;
				});
			})
			.catch(function (error) {
				var message = error.isFormspreeResponse
					? error.message
					: 'Network error. Please try again or email ' + contactEmail + '.';
				setStatus(message, true);
			})
			.then(function () {
				form.removeAttribute('aria-busy');
				submitButton.disabled = false;
			});
	});
})();
