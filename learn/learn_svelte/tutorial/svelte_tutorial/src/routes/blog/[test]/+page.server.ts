import { error } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params }) => {
	// if (params.test === 'hello-world') {
	// 	return {
	// 		title: 'Hello world!',
	// 		content: `${params.test}`
	// 	};
	// } else {
	// 	return {
	// 		title: 'Hello world2!',
	// 		content: `${params.test} + ${typeof params.test}`
	// 	};
	// }
	const post = await getPostFromDatabase(params.test);

	if (post) {
		return {
			status: 200,
			headers: {
				'content-type': 'application/json'
			},
			body: post
		};
	}

	error(404, 'Not found');
};
