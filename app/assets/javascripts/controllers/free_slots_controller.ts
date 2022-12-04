import { Controller } from '@hotwired/stimulus';
import consumer from '../channels/consumer';
// channel.unsubscribe();

export default class extends Controller {
	static values = { date: String };

	declare element: HTMLElement;
	declare dateValue: string;
	declare channel: any;

	connect() {
		console.log("connecting....", this.dateValue)
		this.subscribeToChannel();
	}

	disconnect() {
		this.unsubscribeFromChannel();
	}

	subscribeToChannel() {
		this.channel = consumer.subscriptions.create({ channel: "FreeSlotsChannel", date: this.dateValue }, {
			received(data) {
				console.log(":::::::received data", data);
				const form = document.getElementById('free_slots_filter_form');
				form.querySelector<HTMLButtonElement>('button[type="submit"]').click();
			}
		});
	}

	unsubscribeFromChannel() {
		this.channel.unsubscribe();
	}
}
