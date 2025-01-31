class NonZeroReturnCodeError(Exception):
    def __init__(self, code):
        self.code = code
        self.msg = f'Shell execution return non-zero code.'
        super().__init__(self.msg)

    def __str__(self):
        return f'{self.msg} -> {self.code}'
