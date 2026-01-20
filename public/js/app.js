/**
 * Client API for Kanjo - Emotion journal.
 */
const API_BASE_URL = '/api/journals';

/**
 * Retrieves all journals.
 * @returns {Promise<Array>} List of all journals.
 */
async function getAllJournals() {
  try {
    const response = await fetch(`${API_BASE_URL}/`);
    
    if (!response.ok) {
      throw new Error(`HTTP Error: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('An error has occured when retrieving the journal: ', error);
    throw error;
  }
}

/**
 * Retrieve a specified journal by its date.
 * @param {string} date - Journal date (format: YYYY-MM-DD)
 * @returns {Promise<Object>} The searched journal.
 */
async function getJournal(date) {
  try {
    const response = await fetch(`${API_BASE_URL}/${date}`);
    
    if (!response.ok) {
      throw new Error(`HTTP Error: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error(`An error has occured when retrieving the journal ${date}:`, error);
    throw error;
  }
}

/**
 * Creates a new journal.
 * @param {string} date - The journal date (format: YYYY-MM-DD)
 * @param {string} emotion - Emotion
 * @param {string} content - The journal content in Markdown
 * @param {boolean} readonly - If the journal can be read-only or not.
 * @returns {Promise<Object>} The API response.
 */
async function createJournal(date, emotion, content, readonly = false) {
  try {
    const formData = new FormData();
    formData.append('content', content);
    formData.append('emotion', emotion);
    formData.append('readonly', readonly.toString());
    
    const response = await fetch(`${API_BASE_URL}/create/${date}`, {
      method: 'POST',
      body: formData
    });
    
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.message || `HTTP Error: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('An error has occured when creating the journal: ', error);
    throw error;
  }
}

/**
 * Updates the existing journal.
 * @param {string} date - The journal date (format: YYYY-MM-DD)
 * @param {string} emotion - Emotion
 * @param {string} content - The journal content in Markdown
 * @param {boolean} readonly - If the journal can be read-only or not.
 * @returns {Promise<Object>} The journal response.
 */
async function updateJournal(date, emotion, content, readonly = false) {
  try {
    const formData = new FormData();
    formData.append('content', content);
    formData.append('emotion', emotion);
    formData.append('readonly', readonly.toString());
    
    const response = await fetch(`${API_BASE_URL}/update/${date}`, {
      method: 'PUT',
      body: formData
    });
    
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.message || `HTTP Error: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('An error has occured when updating the journal: ', error);
    throw error;
  }
}

/**
 * Deletes the journal.
 * @param {string} date - The journal date to delete (format: YYYY-MM-DD)
 * @returns {Promise<Object>} The API response.
 */
async function removeJournal(date) {
  try {
    const response = await fetch(`${API_BASE_URL}/delete/${date}`, {
      method: 'DELETE'
    });
    
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.message || `HTTP Error: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('An error has occured when deleting the journal: ', error);
    throw error;
  }
}

/**
 * Formats a date to ISO format (YYYY-MM-DD).
 * @param {Date} date - Date to format.
 * @returns {string} The formated date.
 */
function formatDateISO(date) {
  return date.toISOString().split('T')[0];
}

/**
 * Validates a date.
 * @param {string} dateString - Date to validate (format: YYYY-MM-DD)
 * @returns {boolean} true if the date is valid, otherwise false.
 */
function isValidJournalDate(dateString) {
  const date = new Date(dateString);
  const today = new Date();
  today.setHours(23, 59, 59, 999);
  
  return date <= today;
}

/**
 * Initializes the journal edit form.
 */
function initJournalEditForm() {
  const form = document.getElementById('journal-edit-form');
  const messageDiv = document.getElementById('message');
  
  if (!form)
    return;
  
  const date = form.dataset.journalDate;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const formData = new FormData(form);
    
    // Convert checkbox value to proper format
    if (formData.get('readonly') === 'on')
      formData.set('readonly', 'true');
    else
      formData.set('readonly', 'false');

    try {
      const response = await fetch(`/api/journals/update/${date}`, {
        method: 'PUT',
        body: formData
      });

      const result = await response.json();

      if (response.ok) {
        messageDiv.textContent = 'Journal modifié avec succès !';
        messageDiv.className = 'kanjo-message kanjo-message-success';
        messageDiv.style.display = 'block';

        // Redirect to journal show page after 1.5 seconds
        setTimeout(() => {
          window.location.href = `/journals/${date}`;
        }, 1500);
      } else {
        throw new Error(result.message || 'Erreur lors de la modification du journal');
      }
    } catch (error) {
      messageDiv.textContent = error.message;
      messageDiv.className = 'kanjo-message kanjo-message-error';
      messageDiv.style.display = 'block';
    }
  });
}

if (document.readyState === 'loading')
  document.addEventListener('DOMContentLoaded', initJournalEditForm);
else
  initJournalEditForm();
