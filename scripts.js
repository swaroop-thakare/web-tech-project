/* scripts.js */

/* Voice Alerts Example */
function triggerVoiceAlert(message) {
    const speech = new SpeechSynthesisUtterance(message);
    speech.lang = 'en-US';
    window.speechSynthesis.speak(speech);
}


/* Example: Trigger a voice alert when the page loads */
window.onload = function() {
    triggerVoiceAlert('Welcome to Public Transportation Info. Get updates on schedule changes or delays with real-time voice alerts.');
};

/* Route Planner Form Submission */
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    form.addEventListener('submit', function(event) {
        event.preventDefault();
        const startLocation = document.getElementById('startLocation').value;
        const destination = document.getElementById('destination').value;
        const accessibilityOption = document.getElementById('accessibilityOptions').value;

        const message = `Planning route from ${startLocation} to ${destination} with ${accessibilityOption === '1' ? 'Wheelchair Accessibility' : accessibilityOption === '2' ? 'Low-Vision Friendly' : 'Hearing Impairment Assistance'} selected.`;
        
        triggerVoiceAlert(message);
    });
});
