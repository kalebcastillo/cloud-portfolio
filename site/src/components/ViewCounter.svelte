<script lang="ts">
	import { onMount } from 'svelte';

	let views: number = 0;
	let isLoading = true;

	onMount(async () => {
		// Wait a bit for the counter to be updated in Layout.astro
		await new Promise(resolve => setTimeout(resolve, 100));
		
		if (typeof window !== 'undefined' && window.portfolioViews !== undefined) {
			views = window.portfolioViews;
		}
		
		isLoading = false;
	});
</script>

<div class="flex items-center gap-1">
	{#if isLoading}
		<span class="text-xs opacity-50">Loading...</span>
	{:else}
		<span class="text-lg font-semibold">{views.toLocaleString()}</span>
		<span class="text-xs opacity-75">views</span>
	{/if}
</div>

<style>
</style>
