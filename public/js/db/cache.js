// /public/js/db/cache.js
// Responsabilidad: Interactuar con IndexedDB.

export const db = {
	_dbPromise: null,
	connect() {
		if (this._dbPromise) return this._dbPromise;
		this._dbPromise = new Promise((resolve, reject) => {
			const request = indexedDB.open('VitralesV2DB', 1);
			request.onupgradeneeded = event => {
				const db = event.target.result;
				if (!db.objectStoreNames.contains('schemas')) {
					db.createObjectStore('schemas', { keyPath: 'table_name' });
				}
			};
			request.onsuccess = event => resolve(event.target.result);
			request.onerror = event => reject(event.target.error);
		});
		return this._dbPromise;
	},
	async get(storeName, key) {
		const db = await this.connect();
		return new Promise((resolve, reject) => {
			const transaction = db.transaction(storeName, 'readonly');
			const store = transaction.objectStore(storeName);
			const request = store.get(key);
			request.onsuccess = () => resolve(request.result);
			request.onerror = () => reject(request.error);
		});
	},
	async set(storeName, value) {
		const db = await this.connect();
		return new Promise((resolve, reject) => {
			const transaction = db.transaction(storeName, 'readwrite');
			const store = transaction.objectStore(storeName);
			const request = store.put(value);
			request.onsuccess = () => resolve(request.result);
			request.onerror = () => reject(request.error);
		});
	}
};