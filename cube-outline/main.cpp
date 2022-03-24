/*
  Perspecive Projection chapter. Draw a cube outline.
  Use Vertex Array to draw points.
 */

#include <SFML/Graphics.hpp>

using namespace sf;

int main()
{
  RenderWindow window(VideoMode(800, 600), "Cube Outline");

  // try drawing a line with points
  VertexArray points(Points);

  for (int i = 100, j = 100; i < 200; i++, j+=3)
    {
      float x = (float)i;
      float y = (float)j;
      
      points.append(Vertex(Vector2f(x,y), Color::Green));
    }

  /* 
  // Leaving this in for now just to show how it works.
  Vertex v1(Vector2f(150.f,150.f),Color::Red);
  Vertex v2(Vector2f(155.f,155.f), Color::Blue);
  Vertex v3(Vector2f(160.f,160.f), Color::Green);

  points.append(v1);
  points.append(v2);
  points.append(v3);
  */
  
  while (window.isOpen())
    {
      // check for input
      Event event;

      while (window.pollEvent(event))
	{
	  if (event.type == Event::Closed)
	    window.close();
	  
	  else if (event.type == Event::KeyPressed)
	    {
	      if (Keyboard::isKeyPressed(Keyboard::Escape))
		window.close();
	    }
	  
	} // end check for input

      // drawing

      window.clear(Color::Black);

      window.draw(points);
      
      window.display();
    } // end main while loop

  return 0;
}
