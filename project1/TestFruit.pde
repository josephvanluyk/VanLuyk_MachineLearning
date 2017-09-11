class TestFruit extends Fruit{
	public int FruitID;
	public float height;
	public float width;
	public int guessedFruitID;

    TestFruit(int FruitID, float height, float width){
      super(FruitID, height, width);
      this.FruitID = FruitID;
      this.height = height;
      this.width = width;
    }
	
}