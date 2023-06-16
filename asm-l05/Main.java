public class Main { 
	static float[] coefs = new float[]{2.3f, 3.45f, 7.67f, 5.32f};
	static int degree = 3;
	public static void main(String[] args) {
		double x = 2d;
		double value = evalPoly(coefs, degree, x);
		System.out.println("Value of polynomial is: " + value);
	}
	private static double evalPoly(float[] coefs, int degree, double x) {
		double result = coefs[degree];
		double currentX = x;
		int i = degree - 1;
		for (; i >= 0; i--) {
			result = result + coefs[i] * currentX;
			currentX = currentX * x;
		}
		return result;
	}
}
