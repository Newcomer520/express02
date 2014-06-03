define <[ngMock]>, !->	
	describe 'test all controllers', (,) !->
		beforeEach module 'app'
		it 'should be 1 = 1', !->
			expect(1).toBe 1