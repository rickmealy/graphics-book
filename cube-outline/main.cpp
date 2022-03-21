/*
  Perspecive Projection chapter. Draw a cube outline.
  Starting from a barebones SFML file with circle shape to get the hang of it again.
  Need to read about Vertex Arrays again.
 */

#include <SFML/Graphics.hpp>

using namespace sf;

int main()
{
  RenderWindow window(VideoMode(800, 600), "Cube Outline");

  // testing drawing
  CircleShape shape(50.f);
  shape.setFillColor(Color(100, 250, 50));
  shape.setPosition(100.0f, 100.0f);
  
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

      window.draw(shape);
      
      window.display();
    } // end main while loop

  return 0;
}
