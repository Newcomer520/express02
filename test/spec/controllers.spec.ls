define <[ngMock]>, !->
	beforeEach module 'app'
	describe 'test all controllers', (,) !->
		it 'should be 1 = 1', !->
			expect(1).toBe 1