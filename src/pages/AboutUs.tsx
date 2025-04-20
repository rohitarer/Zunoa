import React from "react";
import { motion } from "framer-motion";
import { BookOpen, Users, FileText, Github, Linkedin } from "lucide-react";
import { Card, CardContent, CardFooter, CardHeader } from "@/components/ui/card";
import { Button } from "@/components/ui/button";

const AboutUs = () => {
  const sections = [
    {
      icon: <BookOpen className="w-8 h-8 text-mann-primary" />,
      title: "Our Mission",
      content:
        "To provide a supportive and accessible platform for individuals seeking mental wellness through innovative technology and compassionate care.",
    },
    {
      icon: <Users className="w-8 h-8 text-mann-primary" />,
      title: "Who We Are",
      content:
        "MANN (Man or Women with No Neurological Nuisance) is a dedicated team of mental health professionals, tech experts, and caring individuals committed to making mental wellness support accessible to everyone.",
    },
    {
      icon: <FileText className="w-8 h-8 text-mann-primary" />,
      title: "Our Approach",
      content:
        "We combine AI technology, peer support, and professional guidance to create a comprehensive mental wellness platform that adapts to your unique needs.",
    },
  ];

  const developers = [
    {
      name: "Anshul Halakarni",
      role: "Project Manager",
      image: "/images/anshul.jpg",
      github: "https://github.com/Anshulhalkarni",
      linkedin: "https://www.linkedin.com/in/anshul-halkarni-016058335",
      bio: "Creative developer focused on building products and experiences",
    },
    {
      name: "Rohit Arer",
      role: "Android Developer",
      image: "/images/rohit.jpg", // from public/images
      github: "https://github.com/rohotarer",
      linkedin: "https://www.linkedin.com/in/rohit-arer-a96294214",
      bio: "Budding Android developer with expertise Flutter",
    },
    {
      name: "Ayush Tammannavar",
      role: "Artificial Intelligence Developer",
      image: "/images/ayush.jpg",
      github: "https://github.com/ayushcodes404",
      linkedin: "https://www.linkedin.com/in/ayush-k-tammannavar-886700300/",
      bio: "Budding AI developer specializing in secure and scalable solutions",
    },
    {
      name: "Suyog Hanamar",
      role: "UI/UX Developer",
      image: "/images/suyog.jpg",
      github: "https://github.com/SUYOGhanamar",
      linkedin: "https://www.linkedin.com/in/suyog-hanamar-57211b300",
      bio: "Making thigs look wow with my expertise in Figma",
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-b from-mann-primary via-mann-secondary to-mann-accent">
      <div className="container mx-auto px-4 py-20">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="text-center text-white mb-16"
        >
          <h1 className="text-4xl md:text-6xl font-bold mb-6">About MANN</h1>
          <p className="text-xl max-w-3xl mx-auto">
            Empowering individuals through technology-driven mental wellness solutions
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          {sections.map((section, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.2 }}
              className="bg-white rounded-lg p-8 shadow-lg"
            >
              <div className="mb-4">{section.icon}</div>
              <h2 className="text-2xl font-semibold text-mann-primary mb-4">
                {section.title}
              </h2>
              <p className="text-gray-600">{section.content}</p>
            </motion.div>
          ))}
        </div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.6 }}
          className="bg-white rounded-lg p-8 shadow-lg max-w-3xl mx-auto mb-16"
        >
          <h2 className="text-2xl font-semibold text-mann-primary mb-4">Our Commitment</h2>
          <p className="text-gray-600 mb-6">
            We believe in creating a safe, inclusive, and supportive environment where everyone can find the help they need. Our platform combines cutting-edge technology with human empathy to provide personalized support for your mental wellness journey.
          </p>
          <p className="text-gray-600">
            Whether through our AI-powered chatbot, anonymous peer support, or professional counseling services, we're here to support you every step of the way.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.8 }}
          className="text-center text-white mb-8"
        >
          <h2 className="text-3xl md:text-4xl font-bold mb-4">Meet Our Developers</h2>
          <p className="text-xl max-w-2xl mx-auto">
            The talented team behind MANN's innovative mental wellness platform
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {developers.map((dev, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.2 + 1 }}
              className={`${
                developers.length === 4 && index === 3 ? "md:col-span-1 md:col-start-2" : ""
              }`}
            >
              <Card className="h-full">
                <CardHeader className="text-center">
                  <img
                    src={dev.image}
                    alt={dev.name}
                    className="w-32 aspect-square object-cover rounded-full mx-auto mb-4"
                  />
                  <h3 className="text-xl font-semibold text-mann-primary">{dev.name}</h3>
                  <p className="text-gray-600">{dev.role}</p>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600 text-center">{dev.bio}</p>
                </CardContent>
                <CardFooter className="justify-center gap-4">
                  <Button variant="outline" size="icon" asChild>
                    <a href={dev.github} target="_blank" rel="noopener noreferrer">
                      <Github className="w-5 h-5" />
                    </a>
                  </Button>
                  <Button variant="outline" size="icon" asChild>
                    <a href={dev.linkedin} target="_blank" rel="noopener noreferrer">
                      <Linkedin className="w-5 h-5" />
                    </a>
                  </Button>
                </CardFooter>
              </Card>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default AboutUs;
